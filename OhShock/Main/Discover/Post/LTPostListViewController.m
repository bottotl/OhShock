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
#import "LTPostCell.h"
#import "LTPostLayout.h"


@interface LTPostListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation LTPostListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[WBStatusHelper imageNamed:@"toolbar_compose_highlighted"] style:UIBarButtonItemStylePlain target:self action:@selector(sendStatus)];
    rightItem.tintColor = [UIColor colorWithHexString:@"fd8224"];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _tableView.frame = self.view.bounds;
    [_tableView registerClass:[LTPostCell class] forCellReuseIdentifier:LTPostCellIdentifier];
    
    LTPostLayout *layout = [LTPostLayout new];
    _dataSource = @[layout].copy;
}

- (void)sendStatus {
    NSLog(@"发表状态");
}


#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTPostCell *cell = [tableView dequeueReusableCellWithIdentifier:LTPostCellIdentifier forIndexPath:indexPath];
    cell.layout = _dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [(LTPostLayout *)_dataSource[indexPath.row] layoutHeight];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


@end
