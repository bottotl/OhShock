//
//  LTDiscoverDynamicViewController.m
//  OhShock
//
//  Created by Lintao.Yu on 12/8/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTDiscoverDynamicViewController.h"

@interface LTDiscoverDynamicViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation LTDiscoverDynamicViewController

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
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"关注动态";
}

#pragma mark - 
#pragma table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [UITableViewCell new];
    return cell;
}



@end
