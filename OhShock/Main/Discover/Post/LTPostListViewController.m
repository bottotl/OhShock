//
//  LTPostListViewController.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/30.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTPostListViewController.h"
#import "LTPostViewCell.h"
#import "LTPostModel.h"
#import "YYKit.h"
#import "LTUploadPhotosViewController.h"
#import "LTPostListService.h"


@interface LTPostListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

/// NSArray <LTPostModel *> * 
@property (nonatomic, strong) NSArray *posts;

/// NSArray < NSNumber *> *
@property (nonatomic, strong) NSArray *heights;

@property (nonatomic, strong) LTPostListService *service;

@end

@implementation LTPostListViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _service = [LTPostListService new];

    self.posts = [NSArray new];
    self.heights = [NSArray new];
    
    [self makeArray];
    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _tableView.frame = self.view.bounds;
    [_tableView registerClass:[LTPostViewCell class] forCellReuseIdentifier:LTPostViewCellIdentifier];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camer_add_post"] style:UIBarButtonItemStylePlain target:self action:@selector(showPostItems)];
    rightItem.tintColor = UIColorHex(fd8224);
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
#pragma mark - 数据
/// 更新数据
- (void)makeArray{
    __weak __typeof(self) weakSelf = self;
    [_service findPost:0 length:10 block:^(NSArray *posts, NSError *error) {
        weakSelf.posts = posts;
        [self updateHeight];
    }];
}
/// 更新高度数据
- (void)updateHeight{
    NSMutableArray *heights = @[].mutableCopy;
    for (LTPostModel *model in self.posts) {
        [heights addObject:@([LTPostView viewHeightWithData:model])];
    }
    self.heights = heights.copy;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTPostViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LTPostViewCellIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((NSNumber *)_heights[indexPath.row]).floatValue;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    LTPostModel *postModel  = self.posts[indexPath.row];
    [(LTPostViewCell *)cell configCellWithData:postModel];
    [[((LTPostViewCell *)cell).postView.rac_gestureSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        //NSLog(@"%@",postModel.profileData.avatarUrlBig);
        NSLog(@"点击了头像%@",x);
    }];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


#pragma mark - 上传事件

#pragma mark 按钮点击
- (void)showPostItems{
    UIAlertController *uploadAlert = [UIAlertController alertControllerWithTitle:@"上传动态" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [uploadAlert addAction:[UIAlertAction actionWithTitle:@"上传图片动态" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"上传图片动态");
    }]];
    [uploadAlert addAction:[UIAlertAction actionWithTitle:@"上传日程动态" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[LTUploadPhotosViewController new]];
        [self.navigationController showDetailViewController:navi sender:self];
        NSLog(@"上传图片动态");
    }]];
    [uploadAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"取消");
    }]];
    [self presentViewController:uploadAlert animated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [self makeArray];
}

@end
