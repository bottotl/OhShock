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
    self.tableView.estimatedRowHeight = 44;
    
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
