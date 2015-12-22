//
//  LTMeViewController.m
//  OhShock
//
//  Created by Lintao.Yu on 12/7/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTMeViewController.h"
#import "UIView+Layout.h"
#import "UIScrollView+APParallaxHeader.h"
#import "UIImage+Common.h"
#import "ODRefreshControl.h"
#import "LTMeHeadView.h"
#import "YYPhotoGroupView.h"
#import "LTMeSettingViewController.h"
#import "LTMeInfoSettingViewController.h"

@interface LTMeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
/// 刷新头
@property (strong, nonatomic) ODRefreshControl *refreshControl;
/// 头部的背景
@property (nonatomic, strong) LTMeHeadView *tableViewHeader;

//@property (nonatomic, strong)

@end

@implementation LTMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [self.view addSubview:self.tableView];
    self.tableView.top = 0;
    self.tableView.left = self.view.left;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableViewHeader = [LTMeHeadView new];
    self.tableViewHeader.contentMode = UIViewContentModeScaleAspectFill;
    self.tableViewHeader.avatorUrlString = @"http://img02.ishuhui.com/op/miao809/01-02.jpg";
    [self.tableView addParallaxWithView:self.tableViewHeader andHeight:LTMeHeadViewHeight];
    
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    
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

- (void)viewWillAppear:(BOOL)animated{
    self.title = @"我";
}


#pragma mark -
#pragma mark tableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 2;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [UITableViewCell new];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell.textLabel setText:@"个人信息"];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        [cell.textLabel setText:@"消息"];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        [cell.textLabel setText:@"收藏"];
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        [cell.textLabel setText:@"设置"];
    }
    
    return cell;
    
}

#pragma mark table View delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self.navigationController pushViewController:[[LTMeInfoSettingViewController alloc]initWithStyle:UITableViewStyleGrouped] animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        [self.navigationController pushViewController:[[LTMeSettingViewController alloc]initWithStyle:UITableViewStyleGrouped] animated:YES];
    }

}

#pragma mark - refresh control
- (void)refresh{
    //self.user = [[JFUserManager manager]getCurrentUser];
    [_refreshControl endRefreshing];
    [self.tableView reloadData];
}
@end
