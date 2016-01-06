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

@interface LTGroupMemberViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation LTGroupMemberViewController{
    UITableView* mainTableView;
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
}

#pragma mark tableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        LTGroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupMemberCell"];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"LTGroupMemberCell" bundle:nil] forCellReuseIdentifier:@"groupMemberCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"groupMemberCell"];
        }
    if (indexPath.row % 2 == 0) {
        [cell.attachImg removeFromSuperview];
        [cell.contentView addConstraint:[NSLayoutConstraint
                                         constraintWithItem:cell.msgContent
                                         attribute:NSLayoutAttributeRight
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:[cell.msgContent superview]
                                         attribute:NSLayoutAttributeRight
                                         multiplier:1
                                         constant:-10]];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
