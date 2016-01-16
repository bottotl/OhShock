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

@interface LTGroupMessageViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation LTGroupMessageViewController{
    UITableView *mainTableView;
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
}

- (void)viewWillAppear:(BOOL)animated{
    self.title = @"群聊消息";
}

#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LTGroupMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupMsgCell"];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"LTGroupMessageCell" bundle:nil] forCellReuseIdentifier:@"groupMsgCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"groupMsgCell"];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
