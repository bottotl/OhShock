//
//  LTUserInfoViewController.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/15.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTUserInfoViewController.h"
#import "LTUserInfoHeadView.h"
#import "UIView+Layout.h"
#import "UIScrollView+APParallaxHeader.h"
#import "UIImage+Common.h"
#import "ODRefreshControl.h"
#import "YYPhotoGroupView.h"
#import "LTUserInfoSendMessageCell.h"

@interface LTUserInfoViewController ()
/// 头部的背景
@property (nonatomic, strong) LTUserInfoHeadView *tableViewHeader;
@end

@implementation LTUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[LTUserInfoSendMessageCell class] forCellReuseIdentifier:LTUserInfoSendMessageCellIdentifier];
    self.tableViewHeader = [LTUserInfoHeadView new];
    self.tableViewHeader.contentMode = UIViewContentModeScaleAspectFill;
    self.tableViewHeader.avatorUrlString = @"http://img02.ishuhui.com/op/miao809/01-02.jpg";
    [self.tableView addParallaxWithView:self.tableViewHeader andHeight:LTUserInfoHeadViewHeight];
    
    [[_tableViewHeader rac_avatorTapGesture]subscribeNext:^(id x) {
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = _tableViewHeader.userAvator;
        item.largeImageURL = [NSURL URLWithString:self.tableViewHeader.avatorUrlString];
        item.largeImageSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
        YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:@[item]];
        [v presentFromImageView:_tableViewHeader.userAvator toContainer:self.tabBarController.view animated:YES completion:nil];
        NSLog(@"点击了头像%@",x);
    }];
    
    [[_tableViewHeader rac_followeeTapGesture]subscribeNext:^(id x) {
        NSLog(@"rac_followeeTapGesture");
    }];
    
    [[_tableViewHeader rac_followerTapGesture]subscribeNext:^(id x) {
        NSLog(@"rac_followerTapGesture");
    }];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"我";
}


#pragma mark -
#pragma mark tableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [UITableViewCell new];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell.textLabel setText:@"消息"];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        [cell.textLabel setText:@"收藏"];
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        LTUserInfoSendMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:LTUserInfoSendMessageCellIdentifier];
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        [[cell rac_signalForSendMessageControlEvents]subscribeNext:^(id x) {
            NSLog(@"我要给你发消息");
        }];
        return cell;
    }
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark table View delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
//        [self.navigationController pushViewController:[[LTMeSettingViewController alloc]initWithStyle:UITableViewStyleGrouped] animated:YES];
    }
    
}

@end
