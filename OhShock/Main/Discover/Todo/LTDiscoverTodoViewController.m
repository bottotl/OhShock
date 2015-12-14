//
//  LTDiscoverTodoViewController.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/11.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTDiscoverTodoViewController.h"
#import "DiscoverTodoCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ODRefreshControl.h"
#import "Masonry.h"

@interface LTDiscoverTodoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *enents;

@end

@implementation LTDiscoverTodoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.tableView.allowsSelection = NO;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.fd_debugLogEnabled = YES;
    [self.tableView registerClass:[DiscoverTodoCell self] forCellReuseIdentifier:JF_Discover_Todo_Cell];
    self.enents = @[].mutableCopy;
    for (int i = 0 ; i <99	; i++) {
        [self.enents addObject:[[LKAlarmEvent alloc]init]];
    }
    
    [self.tableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"日程动态";
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.enents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscoverTodoCell *cell = [tableView dequeueReusableCellWithIdentifier:JF_Discover_Todo_Cell forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(DiscoverTodoCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.fd_enforceFrameLayout = NO;
    cell.entity = self.enents[indexPath.row];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [tableView fd_heightForCellWithIdentifier:JF_Discover_Todo_Cell cacheByIndexPath:indexPath configuration:^(DiscoverTodoCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}


@end
