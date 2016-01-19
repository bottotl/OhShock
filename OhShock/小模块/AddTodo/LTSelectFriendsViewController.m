//
//  LTSelectFriendsViewController.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/30.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTSelectFriendsViewController.h"

@interface LTSelectFriendsViewController ()

@end

@implementation LTSelectFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _friends =@[self.dataSource[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
