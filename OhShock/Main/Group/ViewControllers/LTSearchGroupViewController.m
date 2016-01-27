//
//  LTSearchGroupViewController.m
//  OhShock
//
//  Created by chenlong on 16/1/13.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTSearchGroupViewController.h"
#import "LTGroupService.h"
#import "LTGroupCell.h"
#import "LTGroupInfoViewController.h"

@interface LTSearchGroupViewController ()

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) LTGroupService *service;

@end

@implementation LTSearchGroupViewController

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
    self.title = @"搜索群组";
    _searchBar = [[UISearchBar alloc]
                  initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 45)];
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = NO;
    _searchBar.barStyle=UIBarStyleDefault;
    _searchBar.placeholder=@"Enter Name or Categary";
    _searchBar.keyboardType=UIKeyboardTypeNamePhonePad;
    self.tableView.tableHeaderView = _searchBar;
    
    _dataSource = [NSMutableArray array];
    _service = [LTGroupService new];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell"];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"LTGroupCell" bundle:nil] forCellReuseIdentifier:@"groupCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell"];
    }
    
    [cell setCellWithGroup:_dataSource[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    LTGroupInfoViewController *controller = [[LTGroupInfoViewController alloc]init];
    controller.group = _dataSource[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark UISearchBar Delegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length) {
        [_service findGroupByPartname:searchText complete:^(BOOL succeeded, NSError *error, NSArray *array) {
            if (succeeded) {
                _dataSource = [array mutableCopy];
                [self.tableView reloadData];
            }
        }];
    }
}

@end
