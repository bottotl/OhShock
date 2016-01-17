//
//  LTGroupMessageViewController.m
//  OhShock
//
//  Created by chenlong on 16/1/5.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTGroupMessageViewController.h"
#import "Header.h"
#import "LTGroupMessageCell.h"
#import "LTGroupService.h"
#import "JoinGroupCell.h"

@interface LTGroupMessageViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation LTGroupMessageViewController{
    UITableView *mainTableView;
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
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:mainTableView];
    
    //初始化数据
    dataSource = [NSMutableArray array];
    service = [[LTGroupService alloc]init];
    [self refreshTableData];
}

- (void)refreshTableData{
    [service getUnReadMessagesWithcomplete:^(BOOL succeeded, NSError *error, NSArray *array) {
        dataSource = [array mutableCopy];
        //按消息时间排序
        NSComparator cmptr = ^(id obj1, id obj2){
            LTModelMessage *message1 = (LTModelMessage *)obj1;
            LTModelMessage *message2 = (LTModelMessage *)obj2;
            if ([[message1 objectForKey:@"createdAt"] timeIntervalSinceDate:[message2 objectForKey:@"createdAt"]] < 0) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([[message1 objectForKey:@"createdAt"] timeIntervalSinceDate:[message2 objectForKey:@"createdAt"]] > 0) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        dataSource = [[dataSource sortedArrayUsingComparator:cmptr] mutableCopy];
        [mainTableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    self.title = @"群聊消息";
}

#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    LTGroupMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupMsgCell"];
//    if (cell == nil) {
//        [tableView registerNib:[UINib nibWithNibName:@"LTGroupMessageCell" bundle:nil] forCellReuseIdentifier:@"groupMsgCell"];
//        cell = [tableView dequeueReusableCellWithIdentifier:@"groupMsgCell"];
//    }
//    return cell;
    JoinGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"joinGroupCell"];
    if (cell == nil) {
        cell = [[JoinGroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"joinGroupCell"];
    }
    [cell setCellWithMessage:dataSource[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
