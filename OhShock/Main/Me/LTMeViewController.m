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

@end

@implementation LTMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.top = self.view.top;
    self.tableView.left = self.view.left;
    self.tableView.right = self.view.right;
    self.tableView.bottom = self.view.bottom;
    [self.view addSubview:self.tableView];
    self.tableViewHeader = [LTMeHeadView new];
    self.tableViewHeader.contentMode = UIViewContentModeScaleAspectFill;
    self.tableViewHeader.avatorUrlString = @"http://cdnq.duitang.com/uploads/item/201407/31/20140731215402_xXsve.jpeg";
    [self.tableView addParallaxWithView:self.tableViewHeader andHeight:180];
    
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated{
    self.title = @"我";
}

#pragma mark - layout

- (void)viewDidLayoutSubviews{
    self.tableView.top = self.topLayoutGuide.length;
    //NSLog(@"bottomLayoutGuide:%@",self.bottomLayoutGuide);
    //self.tableView.bottom = self.bottomLayoutGuide.length;
}
#pragma mark -
#pragma mark tableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [UITableViewCell new];
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
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
