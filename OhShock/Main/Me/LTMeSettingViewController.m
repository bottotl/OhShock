//
//  LTMeSettingViewController.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/14.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTMeSettingViewController.h"
#import "LTMeLogOutCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LTLogOutService.h"

@interface LTMeSettingViewController ()
@property (nonatomic, strong) UIButton *signOutButton;

@end

@implementation LTMeSettingViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (instancetype)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    
    [self.tableView registerClass:[LTMeLogOutCell class] forCellReuseIdentifier:@"LTMeLogOutCell"];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0){
        return 1;
    }
    
    if (section == 1) {
        return 2;
    }
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    
    if (indexPath.section == 0) {
        [cell.textLabel setText:@"账号设置"];
    }
    if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"意见反馈"];
        }else{
            [cell.textLabel setText:@"去评分"];
        }
        
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"关于"];
        }else{
            LTMeLogOutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LTMeLogOutCell"];
            
            [cell setNeedsUpdateConstraints];
            [cell updateConstraintsIfNeeded];
            [[cell rac_signalForLogOutControlEvents]subscribeNext:^(id x) {
                [LTLogOutService logOut];
            }];
            return cell;
        }
    }
    
    return cell;
}
@end
