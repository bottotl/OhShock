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
#import "LTChatViewController.h"
#import "LTUserSearchService.h"
#import <AVOSCloud/AVOSCloud.h>

@interface LTUserInfoViewController (){
    LTUserInfoSendMessageCell *messageCell;
}
/// 头部的背景
@property (nonatomic, strong) LTUserInfoHeadView *tableViewHeader;
@property (nonatomic, strong) LTUserSearchService *service;

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;
@end

@implementation LTUserInfoViewController
- (instancetype)initWithAVUser:(AVUser *)user{
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _service = [LTUserSearchService new];
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
    
    messageCell = [LTUserInfoSendMessageCell new];
    [messageCell setNeedsUpdateConstraints];
    [messageCell updateConstraintsIfNeeded];
    [[messageCell rac_signalForSendMessageControlEvents]subscribeNext:^(id x) {
        //NSLog(@"我要给你发消息");
        [self.navigationController pushViewController:[LTChatViewController new] animated:YES];
    }];

    [[_tableViewHeader rac_followeeTapGesture]subscribeNext:^(id x) {
        NSLog(@"rac_followeeTapGesture");
    }];
    
    [[_tableViewHeader rac_followerTapGesture]subscribeNext:^(id x) {
        NSLog(@"rac_followerTapGesture");
    }];
    __weak __typeof(self)weakSelf = self;
    [[_tableViewHeader rac_followButtonOnClick]subscribeNext:^(id x) {
        _tableViewHeader.followButton.enabled = NO;
        [_service changeFollowType:self.user andCallback:^(BOOL succeeded, NSError *error) {
            _tableViewHeader.followButton.enabled = YES;
            if (!error) {
                if (succeeded) {
                    NSLog(@"改变成功");
                    [weakSelf updateInfo];
                }else{
                    NSLog(@"改变失败");
                    [weakSelf updateInfo];
                }
            }else{
                NSLog(@"%@",error);
            }
        }];
    }];
    
    [self updateInfo];
    
}
/// 更新按钮显示
- (void)updateInfo{
    [_service getFollowRelationShipWithMe:self.userId complete:^(LTFollowRelationShipType type, NSError *error) {
        switch (type) {
            case I_FOLLOWED_HIM:
                self.tableViewHeader.followButoonType = followedType;
                break;
            case HE_FOLLOWED_ME:
                self.tableViewHeader.followButoonType = notFollowType;
                break;
            case NO_RELATIONSHIP:
                self.tableViewHeader.followButoonType = notFollowType;
                break;
            case BOTH_FOLLOWED:
                self.tableViewHeader.followButoonType = bothFollowType;
                break;
            default:
                break;
        }
        
    }];
    [_service getFolloweeNum:self.user complete:^(NSUInteger num, NSError *error) {
        self.tableViewHeader.followeeNum = num;
    }];
    [_service getFollowerNum:self.user complete:^(NSUInteger num, NSError *error) {
        self.tableViewHeader.followerNum = num;
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
        cell = messageCell;
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
-(NSString *)userId{
    return self.user.objectId;
}

@end
