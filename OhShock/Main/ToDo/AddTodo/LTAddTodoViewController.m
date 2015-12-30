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

@interface LTAddTodoViewController (){
    /**
     *  表示是否选择了时间(用在 didSelectRowAtIndex 函数中)
     *  方便判断时间 timeCell 对话框的 timePicker 弹出逻辑
     *
     *  isDataSelected == YES 需要显示 timeCell
     *
     *  isDataSelected == NO 不需要显示 timeCell
     */
    BOOL isDataSelected;
    /// timeCell 是否已插入
    BOOL isTimeCellInserted;
}
@property (nonatomic, copy)   NSString        *text;
@property (nonatomic, strong) NSDate          *date;
@property (nonatomic, strong) NSDate          *time;
@property (nonatomic, strong) NSMutableArray  *dataSource;
@property (nonatomic, strong) LTAddTodoSelectionCell *timeCell;
@end

@implementation LTAddTodoViewController

-(instancetype)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    
//    isDataSelected = NO;
    isTimeCellInserted = NO;
    UIBarButtonItem *saveBarItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    UIBarButtonItem *cancleBarItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    self.navigationItem.leftBarButtonItems = @[cancleBarItem];
    self.navigationItem.rightBarButtonItems = @[saveBarItem];
    
    _dataSource = [NSMutableArray new];
    
    NSMutableArray *section1 =[NSMutableArray new];
    [section1 addObject:[LTAddTodoTextCell new]];
    [_dataSource addObject:section1.copy];
    
    NSMutableArray *section2 =[NSMutableArray new];
    [section2 addObject:[[LTAddTodoSelectionCell alloc]initWithImage:nil leftText:@"所属类别" rightText:nil]];
    [section2 addObject:[[LTAddTodoSelectionCell alloc]initWithImage:nil leftText:@"开始时间" rightText:nil]];
    [section2 addObject:[[LTAddTodoSelectionCell alloc]initWithImage:nil leftText:@"邀请参与" rightText:nil]];
    [_dataSource addObject:section2];
    _timeCell = [[LTAddTodoSelectionCell alloc]initWithImage:nil leftText:@"结束时间" rightText:nil];
    
}
#pragma mark - 取消日程创建
-(void)cancle{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 完成日程创建
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
            
            if(alarmEvent.isJoinedCalendar)
            {
                printf("已加入日历\n");
            }
            else if(alarmEvent.isJoinedLocalNotify)
            {
                printf("已加入本地通知\n");
            }
            else
            {
                printf("加入通知失败\n");
            }
            
        });
        
    }];
}

#pragma mark - 添加选择时间的 Cell
- (void)addTimeCell{
    if (!isTimeCellInserted) {
        [_dataSource[1] insertObject:_timeCell atIndex:2];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationBottom];
        isTimeCellInserted = YES;
    }
    
}
#pragma mark  移除选择时间的 Cell
- (void)deleteTimeCell{
    if (isTimeCellInserted) {
        [_dataSource[1] removeObjectAtIndex:2];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationBottom];
        isTimeCellInserted = NO;
    }
    
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
#pragma mark 选择开始时间控件
        ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:nil datePickerMode:UIDatePickerModeDateAndTime selectedDate:curDate doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
            _date = selectedDate;
            isDataSelected = YES;
            [self.tableView reloadData];
            [self addTimeCell];
        } cancelBlock:^(ActionSheetDatePicker *picker) {
            if (picker.cancelButtonClicked) {
                isDataSelected = NO;
                _date = nil;
                [self.tableView reloadData];
                [self deleteTimeCell];
            }
        } origin:self.view];
        
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"移除" style:UIBarButtonItemStylePlain target:nil action:nil];
        [barButton setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17],
                                            NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateNormal];
        [datePicker setCancelButton:barButton];
        [datePicker showActionSheetPicker];
    }
    // 如果 isDataSelected == YES，那[1][2]表示的就是 timeCell 需要弹出 timePicker
    if(isDataSelected && indexPath.section == 1 && indexPath.row == 2 ){
        NSDate * curtime ;
        if (!_time) {
            curtime = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
        }else{
            curtime = _time;
        }
#pragma mark 选择结束时间控件
        ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:nil datePickerMode:UIDatePickerModeDateAndTime selectedDate:curtime doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
            _time = selectedDate;
            [self.tableView reloadData];
        } cancelBlock:^(ActionSheetDatePicker *picker) {
            if (picker.cancelButtonClicked) {
                _time = nil;
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
    
    return ((NSArray *)_dataSource[section]).count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = _dataSource[indexPath.section][indexPath.row];
    if (indexPath.section == 1 && indexPath.row == 1) {
        ((LTAddTodoSelectionCell *)cell).rightText = [_date stringWithFormat:@"yyyy-MM-dd HH:mm"];
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
    }
    if (isDataSelected && indexPath.section == 1 && indexPath.row == 2) {
        ((LTAddTodoSelectionCell *)cell).rightText = [_time stringWithFormat:@"yyyy-MM-dd HH:mm"];
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
    }
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
