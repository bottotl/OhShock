//
//  LTDiscoverTodoViewController.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/11.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTDiscoverTodoViewController.h"
#import "LTDiscoverTodoViewCell.h"
#import "ODRefreshControl.h"
#import "Masonry.h"

@interface LTDiscoverTodoViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ODRefreshControl *refreshControl;

@property (strong, nonatomic) NSMutableDictionary *offscreenCells;
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.and.top.equalTo(self.view);
    }];
    
    
    
    self.offscreenCells = [NSMutableDictionary dictionary];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.tableView.allowsSelection = NO;
    [self.tableView registerClass:[LTDiscoverTodoViewCell class] forCellReuseIdentifier:LTDiscoverTodoViewCellIdentifier];

    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"日程动态";
}

#pragma mark -
#pragma table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LTDiscoverTodoViewCell * cell = [tableView dequeueReusableCellWithIdentifier:LTDiscoverTodoViewCellIdentifier forIndexPath:indexPath];
    
    //设置cell内容
    //[cell updateFonts];
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return cell;

}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = LTDiscoverTodoViewCellIdentifier;
    
    LTDiscoverTodoViewCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
    if (!cell) {
        //cell = [[ScheduleCell alloc] init];
        cell = [[LTDiscoverTodoViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [self.offscreenCells setObject:cell forKey:reuseIdentifier];
    }
    //设置cell内容
    //[cell updateFonts];
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    // Get the actual height required for the cell
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // Add an extra point to the height to account for the cell separator, which is added between the bottom
    // of the cell's contentView and the bottom of the table view cell.
    height += 1;
    
    return height;
}


@end
