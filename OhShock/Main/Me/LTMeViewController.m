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
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [self.view addSubview:self.tableView];
    self.tableView.top = 0;
    self.tableView.left = self.view.left;
    
    self.tableViewHeader = [LTMeHeadView new];
    self.tableViewHeader.contentMode = UIViewContentModeScaleAspectFill;
    self.tableViewHeader.avatorUrlString = @"https://coding.net//static/fruit_avatar/Fruit-2.png";
    [self.tableView addParallaxWithView:self.tableViewHeader andHeight:LTMeHeadViewHeight];
    
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated{
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
        [cell.textLabel setText:@"设置"];
    }
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark - refresh control
- (void)refresh{
    //self.user = [[JFUserManager manager]getCurrentUser];
    [_refreshControl endRefreshing];
    [self.tableView reloadData];
}
@end
