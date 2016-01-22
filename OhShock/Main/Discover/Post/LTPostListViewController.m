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
#import "LTPostModel.h"


static NSUInteger const onceLoadPostNum = 10;
@interface LTPostListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

/// < NSNumber *> *
//@property (nonatomic, strong) NSMutableArray *heights;

@property (nonatomic, strong) LTPostListService *service;

@property (nonatomic, strong) NSMutableArray *posts;

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

//-(NSMutableArray *)heights{
//    if (!_heights) {
//        _heights = @[].mutableCopy;
//    }
//    return _heights;
//}

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
            self.lastPostCount += objects.count;
//            [weakSelf updateHeight];
        }
    }];
}

/// 更新高度数据
//- (void)updateHeight{
//    __weak __typeof(self) weakSelf = self;
//    for (LTModelPost *model in self.dataSource) {
//        LTModelUser *user = [model objectForKey:@"pubUser"];
//        AVQuery *query = [AVQuery queryWithClassName:@"_User"];
//        [query whereKey:@"objectId" equalTo:user.objectId];
//        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//            if (objects && objects.count > 0) {
//                LTModelUser *user = [objects firstObject];
//                NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSRTFTextDocumentType};
//                NSAttributedString *content = [[NSAttributedString alloc]initWithData:[model objectForKey:@"content"] options:options documentAttributes:nil error:nil];
//                
//                [weakSelf.heights addObject:@([LTPostView heightWithContent:content
//                                                                andPicCound:model.photos.count
//                                                               andUsersName:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",user.username]]
//                                                                andComments:model.comments
//                                                             andCommitLimit:6
//                                                             andCommentFold:NO
//                                                           andPreferedWidth:[UIScreen mainScreen].bounds.size.width])];
//                [weakSelf.tableView reloadData];
//                
//            }
//        }];
//        
//    }
//}
//- (LTModelUser *)p_getUser:(LTModelUser *)user{
//    AVQuery *queue = [LTModelUser query];
//}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTPostViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LTPostViewCellIdentifier forIndexPath:indexPath];
    LTModelPost *post = self.dataSource[indexPath.row];
    [cell.postView.imagesView configViewWithPicNum:post.photos.count needBig:YES itemSpace:6 limit:9];
    [[cell.postView.rac_likeSignal takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(id x) {
        LTPostViewRoundButton *button = x;
        cell.postView.liked = !cell.postView.liked ;
        button.enabled = NO;/// 点击一次之后不允许点击了
        
        LTModelPost *post = self.dataSource[indexPath.row];
        BOOL needRemove = NO;// 标记需要移除还是添加
        NSMutableArray *likedUsers = [[NSMutableArray alloc]initWithArray:post.likedUser];
        for (LTModelUser *user in likedUsers) {
            if([user.objectId isEqualToString:([LTModelUser currentUser].objectId)]){
                [likedUsers removeObject:user];
                needRemove = YES;
                break;
            }
        }
        
        if (needRemove || likedUsers.count == 0) {
            [likedUsers addObject:[LTModelUser currentUser]];
        }
        post.likedUser = likedUsers.copy;
        [post saveEventually];
//        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (succeeded) {
//                button.enabled = YES;/// 保存结束，设置可以点击点赞
//            }else{
//                NSLog(@"%@",error);
//            }
//        }];
    }];
    [[cell.postView.rac_commitSignal takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(id x){
        NSLog(@"评论 %@",x);
        
    }];
    return cell;
}

#pragma mark  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTPostModel *post = self.posts[indexPath.row];
    return [LTPostView heightWithContent:post.content
                               andPicCound:post.picUrls.count
                              andUsersName:[[NSAttributedString alloc]initWithString:post.userName]
                               andComments:post.comments
                            andCommitLimit:6
                            andCommentFold:NO
                          andPreferedWidth:[UIScreen mainScreen].bounds.size.width];

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    LTPostView *postView = ((LTPostViewCell *)cell).postView;
    LTModelPost *post = self.dataSource[indexPath.row];
    
    /// 个人信息填充
    // 这时候用户内部没有数据 得去查一遍
    AVQuery *query = [LTModelUser query];
    [query setCachePolicy:kAVCachePolicyCacheElseNetwork];
    [query whereKey:@"objectId" equalTo:post.pubUser.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects && objects.count > 0) {
            LTModelUser *user = [objects firstObject];
            postView.profileView.name = user.username;
            AVFile *avatar = user.avatar;
            [avatar getThumbnail:YES width:LTPostProfileViewAvatarViewHeight height:LTPostProfileViewAvatarViewHeight withBlock:^(UIImage *thumbImage, NSError *error) {
                postView.profileView.avatarView.image = thumbImage;
            }];
        }
    }];
    
    /// 文字内容填充
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSRTFTextDocumentType};
    postView.contentView.content = [[NSAttributedString alloc]initWithData:[post objectForKey:@"content"] options:options documentAttributes:nil error:nil];
    
    /// 图片内容填充
    for (int i = 0; i < post.photos.count; i++) {
        AVFile *photo = post.photos[i];
        
        // 这时候 photo 内部没有数据 得去查一遍
        AVQuery *query = [AVFile query];
        __weak LTPostView * weakPostView = postView;
        [query whereKey:@"objectId" equalTo:photo.objectId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects && objects.count > 0) {
                AVFile *file = [AVFile fileWithAVObject:[objects firstObject]];
                [file getThumbnail:YES width:150 height:150 withBlock:^(UIImage *image, NSError *error) {
                    [weakPostView.imagesView.photos setObject:image forKey:[NSString stringWithFormat:@"%lu",(unsigned long)i]];
                    [weakPostView.imagesView.collectionView reloadData];
//                    [weakPostView.imagesView.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
                }];
            }
        }];
        
        
    }
    

    
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
