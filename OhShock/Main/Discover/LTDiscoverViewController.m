//
//  LTDiscoverViewController.m
//  OhShock
//
//  Created by Lintao.Yu on 12/7/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTDiscoverViewController.h"
#import "UIView+Layout.h"
#import "LTDiscoverCell.h"
#import "Masonry.h"
#import "LTDiscoverTodoViewController.h"
#import "LTPostListViewController.h"

@interface LTDiscoverViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) LTDiscoverTodoViewController *todoViewController;

@property (nonatomic, strong) LTPostListViewController *postViewController;

@end

@implementation LTDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView  = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[LTDiscoverCell class] forCellReuseIdentifier:LTDiscoverCellIdentifier];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.and.top.equalTo(self.view);
    }];
    
    [self.view setNeedsLayout];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"发现";
}

#pragma mark - property
-(NSArray *)dataSource{
    if (!_dataSource) {
        NSArray *section0 = @[@{@"image":[UIImage imageNamed:@"found_dynamic"],@"title":@"关注动态"}];
        NSArray *section1 = @[@{@"image":[UIImage imageNamed:@"found_plan"]
                            ,@"title":@"热门计划"}
                          ,@{@"image":[UIImage imageNamed:@"found_local"]
                             ,@"title":@"同城用户"}
                          ,@{@"image":[UIImage imageNamed:@"found_localplan"]
                             ,@"title":@"同城计划"}];
        NSArray *section2 = @[@{@"image":[UIImage imageNamed:@"found_people"]
                            ,@"title":@"红人榜"}];
        _dataSource = [NSArray arrayWithObjects:section0,section1,section2, nil];
    }
    return _dataSource;
}

#pragma mark View

-(LTDiscoverTodoViewController *)todoViewController{
    if (!_todoViewController) {
        _todoViewController = [LTDiscoverTodoViewController new];
        _todoViewController.hidesBottomBarWhenPushed = YES;
    }
    return _todoViewController;
}

-(LTPostListViewController *)postViewController{
    if (!_postViewController) {
        _postViewController  = [LTPostListViewController new];
        _postViewController.hidesBottomBarWhenPushed = YES;
    }
    return _postViewController;
}

#pragma mark -
#pragma mark TableView data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *sectionArray = self.dataSource[section];
    return sectionArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LTDiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:LTDiscoverCellIdentifier];
    NSDictionary *dic = self.dataSource[indexPath.section][indexPath.row];
    [cell setWithImage:[dic objectForKey:@"image"] title:[dic objectForKey:@"title"]];
    return cell;
}
#pragma mark tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:self.postViewController animated:YES];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:self.todoViewController animated:YES];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            [self.navigationController pushViewController:self.postViewController animated:YES];
        }
    }
}
@end
