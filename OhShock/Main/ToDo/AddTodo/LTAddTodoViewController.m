//
//  LTAddTodoViewController.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/24.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTAddTodoViewController.h"
#import "ActionSheetDatePicker.h"
#import "LTAddTodoSelectionCell.h"
#import "LTAddTodoTextCell.h"
#import "NSDate+Helper.h"
#import "LKAlarmMamager.h"

@interface LTAddTodoViewController ()
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSDate *date;
@end

@implementation LTAddTodoViewController

-(instancetype)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[LTAddTodoSelectionCell class]forCellReuseIdentifier:LTAddTodoSelectionCellIdentifier];
    [self.tableView registerClass:[LTAddTodoTextCell class] forCellReuseIdentifier:LTAddTodoTextCellIdentifier];
    UIBarButtonItem *saveBarItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    UIBarButtonItem *cancleBarItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    self.navigationItem.leftBarButtonItems = @[cancleBarItem];
    self.navigationItem.rightBarButtonItems = @[saveBarItem];
    
}
-(void)cancle{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)save{
    [self createReminder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)createReminder{
    LKAlarmEvent* event = [LKAlarmEvent new];
    event.title = @"参试加入日历事件中";
    event.content = @"只有加入到日历当中才有用，是日历中的备注";
    ///工作日提醒
    event.repeatType = LKAlarmRepeatTypeWork;
    ///??秒后提醒我
    if (self.date) {
        event.startDate = self.date;
    }else{
        return;
    }
    //event.startDate = [NSDate dateWithTimeIntervalSinceNow:3];
    
    NSLog(@"Date:%@ ",event.startDate);
    ///也可以强制加入到本地提醒中
    //event.isNeedJoinLocalNotify = YES;
    
    ///会先尝试加入日历  如果日历没权限 会加入到本地提醒中
    [[LKAlarmMamager shareManager] addAlarmEvent:event callback:^(LKAlarmEvent *alarmEvent) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //UILabel* label = ((ViewController*)_window.rootViewController).lb_haha;
            if(alarmEvent.isJoinedCalendar)
            {
                //label.text = @"已加入日历";
                printf("已加入日历\n");
            }
            else if(alarmEvent.isJoinedLocalNotify)
            {
                //label.text = @"已加入本地通知";
                printf("已加入本地通知\n");
            }
            else
            {
                //label.text = @"加入通知失败";
                printf("加入通知失败\n");
            }
            
        });
        
    }];
}
#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 1) {
        NSDate * curDate ;
        if (!_date) {
            curDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
        }else{
            curDate = _date;
        }
        ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:nil datePickerMode:UIDatePickerModeDate selectedDate:curDate doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
            _date = selectedDate;
            [self.tableView reloadData];
        } cancelBlock:^(ActionSheetDatePicker *picker) {
            if (picker.cancelButtonClicked) {
                _date = nil;
                [self.tableView reloadData];
            }
        } origin:self.view];
        
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"移除" style:UIBarButtonItemStylePlain target:nil action:nil];
        [barButton setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17],
                                            NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateNormal];
        [datePicker setCancelButton:barButton];
        [datePicker showActionSheetPicker];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else{
        return 3;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:LTAddTodoTextCellIdentifier forIndexPath:indexPath];
        [cell setNeedsUpdateConstraints];
        return cell;
    }
    LTAddTodoSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:LTAddTodoSelectionCellIdentifier forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            [cell ConfigeCell:[UIImage imageNamed:@"found_dynamic"] leftText:@"所属类别" rightText:nil];
            break;
        case 1:
            [cell ConfigeCell:[UIImage imageNamed:@"found_dynamic"] leftText:@"执行时间" rightText:[_date stringWithFormat:@"yyyy-MM-dd"]];
            break;
        case 2:
            [cell ConfigeCell:[UIImage imageNamed:@"found_dynamic"] leftText:@"邀请参与" rightText:nil];
            break;
        default:
            break;
    }
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 130;
        
    }else{
        return 60;
    }
}



@end
