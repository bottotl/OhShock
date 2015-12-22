//
//  LTMeInfoSettingViewController.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/22.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTMeInfoSettingViewController.h"
#import "LTMeHeaderCell.h"

@interface LTMeInfoSettingViewController ()
//@property (nonatomic, strong)
@end

@implementation LTMeInfoSettingViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (instancetype)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0){
        return 1;
    }
    
    if (section == 1) {
        return 2;
    }
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    
    if (indexPath.section == 0) {
        [cell.textLabel setText:@"头像"];
    }
    
    return cell;
}

@end
