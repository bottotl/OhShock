//
//  LTPostListViewController.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/30.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTPostListViewController.h"
#import "LTPostViewCell.h"
#import "YYKit.h"
#import "LTUploadPhotosViewController.h"
#import "LTPostListService.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LTModelPost.h"

static NSUInteger const onceLoadPostNum = 10;
@interface LTPostListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

/// <LTPostModel *> *
@property (nonatomic, strong) NSMutableArray <LTPostModel *> *posts;

/// < NSNumber *> *
@property (nonatomic, strong) NSMutableArray *heights;

@property (nonatomic, strong) LTPostListService *service;

@property (nonatomic, assign) NSUInteger lastPostCount;

/// LTPostModel
@property (nonatomic, strong) NSMutableArray <LTModelPost *> *dataSource;


@end

@implementation LTPostListViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _service = [LTPostListService new];
    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _tableView.frame = self.view.bounds;
    [_tableView registerClass:[LTPostViewCell class] forCellReuseIdentifier:LTPostViewCellIdentifier];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camer_add_post"] style:UIBarButtonItemStylePlain target:self action:@selector(showPostItems)];
    rightItem.tintColor = UIColorHex(fd8224);
    self.navigationItem.rightBarButtonItem = rightItem;
    [self loadMorePostList];
    
}

#pragma mark property
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}
-(NSMutableArray *)posts{
    if (!_posts) {
        _posts = @[].mutableCopy;
    }
    return _posts;
}
-(NSMutableArray *)heights{
    if (!_heights) {
        _heights = @[].mutableCopy;
    }
    return _heights;
}

#pragma mark - 数据
// 加载一次 post
-(void)loadMorePostList{
    __weak __typeof(self) weakSelf = self;
    AVQuery *query = [LTModelPost query];
    [query orderByDescending:@"createdAt"];
    query.skip = self.lastPostCount ;
    query.limit = onceLoadPostNum;
    [query setCachePolicy:kAVCachePolicyNetworkElseCache];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }else{
            [weakSelf.dataSource addObjectsFromArray:objects];
            [weakSelf updateHeight];
        }
    }];
}

/// 更新高度数据
- (void)updateHeight{
    __weak __typeof(self) weakSelf = self;
    for (LTModelPost *model in self.dataSource) {
        LTModelUser *user = [model objectForKey:@"pubUser"];
        AVQuery *query = [AVQuery queryWithClassName:@"_User"];
        [query whereKey:@"objectId" equalTo:user.objectId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects && objects.count > 0) {
                LTModelUser *user = [objects firstObject];
                NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSRTFTextDocumentType};
                NSAttributedString *content = [[NSAttributedString alloc]initWithData:[model objectForKey:@"content"] options:options documentAttributes:nil error:nil];
                
                [weakSelf.heights addObject:@([LTPostView heightWithContent:content
                                                                andPicCound:model.photos.count
                                                               andUsersName:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",user.username]]
                                                                andComments:model.comments
                                                             andCommitLimit:6
                                                             andCommentFold:NO
                                                           andPreferedWidth:[UIScreen mainScreen].bounds.size.width])];
                
                [weakSelf.tableView reloadData];
            }
        }];
        
    }
}
//- (LTModelUser *)p_getUser:(LTModelUser *)user{
//    AVQuery *queue = [LTModelUser query];
//}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTPostViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LTPostViewCellIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((NSNumber *)self.heights[indexPath.row]).floatValue;

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    LTPostViewCell *p_cell = (LTPostView *)cell;
//    p_cell
//    LTPostModel *postModel  = self.posts[indexPath.row];
//    [(LTPostViewCell *)cell configCellWithData:postModel];
//    [[((LTPostViewCell *)cell).postView.rac_gestureSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
//        //NSLog(@"%@",postModel.profileData.avatarUrlBig);
//        NSLog(@"点击了头像%@",x);
//    }];
//    [cell setNeedsLayout];
//    [cell layoutIfNeeded];
    
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


#pragma mark - 上传事件

#pragma mark 按钮点击
- (void)showPostItems{
    UIAlertController *uploadAlert = [UIAlertController alertControllerWithTitle:@"上传动态" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [uploadAlert addAction:[UIAlertAction actionWithTitle:@"上传图片动态" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self loadMorePostList];
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



@end
