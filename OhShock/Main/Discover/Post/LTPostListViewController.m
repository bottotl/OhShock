//
//  LTPostListViewController.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/30.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTPostListViewController.h"
#import "UIColor+expanded.h"
#import "WBStatusHelper.h"


@interface LTPostListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation LTPostListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[WBStatusHelper imageNamed:@"toolbar_compose_highlighted"] style:UIBarButtonItemStylePlain target:self action:@selector(sendStatus)];
    rightItem.tintColor = [UIColor colorWithHexString:@"fd8224"];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _tableView.frame = self.view.bounds;
    
    
}

- (void)sendStatus {
    NSLog(@"发表状态");
}


#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


@end
