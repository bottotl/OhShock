//
//  LTPostListViewController.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/30.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTPostListViewController.h"
#import "UIColor+expanded.h"
#import "WBStatusHelper.h"
#import "LTPostViewCell.h"
#import "LTPostLayout.h"
#import "LTPostModel.h"


@interface LTPostListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

/// @[<LTPostModel *>]
@property (nonatomic, strong) NSArray *posts;

/// @[< NSNumber *>]
@property (nonatomic, strong) NSArray *heights;
@end

@implementation LTPostListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[WBStatusHelper imageNamed:@"toolbar_compose_highlighted"] style:UIBarButtonItemStylePlain target:self action:@selector(sendStatus)];
    rightItem.tintColor = [UIColor colorWithHexString:@"fd8224"];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _tableView.frame = self.view.bounds;
    [_tableView registerClass:[LTPostViewCell class] forCellReuseIdentifier:LTPostViewCellIdentifier];
    
}

- (void)sendStatus {
    NSLog(@"发表状态");
}

- (void)makeArray{
    LTPostModel *mode = [LTPostModel new];
    
    LTPostProfileModel *profileData = [LTPostProfileModel new];
    LTPostContentModel *contentData = [LTPostContentModel new];
    
    profileData.avatarUrl = @"http://ww4.sinaimg.cn/mw690/6b5f103fjw8em2xe1lm4wj20qm0qnadp.jpg";
    profileData.name = @"jft0m";
    
    contentData.content = [[NSAttributedString alloc]initWithString:@"阿萨德飞离开家或第三方了看见的回复了即可恢复到上公开了几乎是发达了回复了就开始打了积分卡喝多了快解放和大厦里即可回答了客家话阿里开奖号"];
    
    LTPostImageModel *postImageData = [LTPostImageModel new];
    postImageData.smallUrlString = @"http://ww3.sinaimg.cn/mw690/6b5f103fjw8ezoov1yvggj20p00p0q59.jpg";
    postImageData.bigUrlString = @"http://ww4.sinaimg.cn/mw690/6b5f103fjw8em2xe1lm4wj20qm0qnadp.jpg";
    NSMutableArray *tempPostImagesData = @[].mutableCopy;
    for (int i = 0; i < 9; i++) {
        [tempPostImagesData addObject:postImageData];
    }
    NSArray *postImagesData = tempPostImagesData.copy;
    
    mode.profileData = profileData;
    mode.contentData = contentData;
    mode.pic = postImagesData.copy;

    NSMutableArray *tempDataSource = @[].mutableCopy;
    for (int i = 0; i < 60; i++) {
        [tempDataSource addObject:mode];
    }
    
    
    NSMutableArray *heights = @[].mutableCopy;
    for (LTPostModel *model in tempDataSource) {
        [heights addObject:@([LTPostView viewHeightWithData:model])];
    }
    
    self.posts = tempDataSource.copy;
    self.heights = heights.copy;
    
}

#pragma mark - table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTPostViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LTPostViewCellIdentifier forIndexPath:indexPath];
    [cell configCellWithData:self.posts[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((NSNumber *)_heights[indexPath.row]).floatValue;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


@end
