//
//  LTAddFriendViewController.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/15.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTAddFriendViewController.h"
#import "LTLiteUserCell.h"
#import "ReactiveCocoa.h"
#import "LTUserSearchService.h"
#import <AVOSCloud/AVOSCloud.h>
#import "UISearchBar+RACSignalSupport.h"
#import "LTUserInfoViewController.h"

@interface LTAddFriendViewController ()

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) LTUserSearchService *service;
@end

@implementation LTAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchBar = [[UISearchBar alloc]
                                initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 45)];
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = NO;
    _searchBar.barStyle=UIBarStyleDefault;
    _searchBar.placeholder=@"Enter Name or Categary";
    _searchBar.keyboardType=UIKeyboardTypeNamePhonePad;
    self.tableView.tableHeaderView = _searchBar;
    [self.tableView registerClass:[LTLiteUserCell class] forCellReuseIdentifier:LTLiteUserCellIdentifier];
    
    _dataSource = [NSArray new];
    
    _service = [LTUserSearchService new];
    [[self userSearchSignal]subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSArray class]]) {
            NSArray * array = (NSArray *)x;
            _dataSource = array.copy;
            [self.tableView reloadData];
            NSLog(@"_dataSource.count = %ld",_dataSource.count);
        }else{
            NSError *error = x;
            NSLog(@"%@",error);
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTLiteUserCell *cell = [tableView dequeueReusableCellWithIdentifier:LTLiteUserCellIdentifier forIndexPath:indexPath];
    AVUser *user = _dataSource[indexPath.row];
    cell.userName = [user username];
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LTModelUser *user = _dataSource[indexPath.row];
    [self.navigationController pushViewController:[[LTUserInfoViewController alloc]initWithAVUser:user] animated:YES];
}

#pragma mark - RACSignal
#pragma mark  搜索框信号
- (RACSignal *)searchBarSignal{
    return [RACSignal merge:@[self.searchBar.rac_textSignal, RACObserve(self.searchBar, text)]];
}
#pragma mark  搜索用户信号
- (RACSignal *)userSearchSignal {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        [[self searchBarSignal]subscribeNext:^(NSString *text) {
            NSLog(@"text %@",text);
            if (text.length > 0) {
                [self.service findUsersByPartname:text complete:^(NSArray *users, NSError *error) {
                    if (!error) {
                        [subscriber sendNext:users];
                    }else{
                        [subscriber sendNext:error];
                    }
                }];
            }
            
        }];
        return nil;
    }];
}



@end
