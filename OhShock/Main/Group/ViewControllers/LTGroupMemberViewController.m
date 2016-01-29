//
//  LTGroupMemberViewController.m
//  OhShock
//
//  Created by chenlong on 16/1/6.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTGroupMemberViewController.h"
#import "Header.h"
#import "LTGroupMemberCell.h"
#import "LTGroupService.h"

@interface LTGroupMemberViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation LTGroupMemberViewController{
    UITableView* mainTableView;
    NSMutableArray *dataSource;

    LTGroupService *service;
}

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
    // Do any additional setup after loading the view.
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 99) style:UITableViewStylePlain];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:mainTableView];
    
    //初始化数据
    dataSource = [NSMutableArray array];
    service = [[LTGroupService alloc]init];
    [self refreshTableData];
}

//刷新数据源
- (void)refreshTableData{
    [service getMembersOfGroup:_group andCallback:^(BOOL succeeded, NSError *error, NSArray *array) {
        dataSource = [array mutableCopy];
        [mainTableView reloadData];
    }];
}

#pragma mark tableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    LTGroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupMemberCell"];
    if (cell == nil) {
        cell = [[LTGroupMemberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"groupMemberCell"];
    }
    [cell setCellWith:dataSource[indexPath.row]];
//    if (indexPath.row % 2 == 0) {
//        [cell.attachImg removeFromSuperview];
//        [cell.contentView addConstraint:[NSLayoutConstraint
//                                         constraintWithItem:cell.msgContent
//                                         attribute:NSLayoutAttributeRight
//                                         relatedBy:NSLayoutRelationEqual
//                                         toItem:[cell.msgContent superview]
//                                         attribute:NSLayoutAttributeRight
//                                         multiplier:1
//                                         constant:-10]];
//    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
