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

//@property (nonatomic, strong) LTPostListService *service;

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
    
//    _service = [LTPostListService new];
    
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
    if(!_posts){
        _posts = @[].mutableCopy;
    }
    return _posts;
}
-(NSUInteger)lastPostCount{
    return self.posts.count;
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
            NSMutableArray < LTPostModel *> *onceLoadPostsArray = [[NSMutableArray alloc]initWithCapacity:objects.count];
            for (int i = 0; i < objects.count; i ++) {
                LTModelPost *model = objects[i];
                [weakSelf p_dequePostFromModel:model block:^(LTPostModel *post, NSError *error) {
                    if (!error) {
                        onceLoadPostsArray[i] = post;
                        if (i == objects.count - 1) {
                            [self.posts addObjectsFromArray:onceLoadPostsArray.copy];
                            NSLog(@"post 加载完成");
                            [weakSelf.tableView reloadData];
                        }
                    }else{
                        NSLog(@"加载 post 错误 %@ ",error);
                    }
                }];
            }
        }
    }];
}

-(void)p_dequePostFromModel:(LTModelPost *)model block:(void(^)(LTPostModel *post, NSError *error))block{
    __block LTPostModel *post = [LTPostModel new];
    NSError *error = nil;
    /// 个人信息
    LTModelUser *modelUser = [model objectForKey:@"pubUser"];
    AVQuery *userQuery = [AVQuery queryWithClassName:@"_User"];
//    [userQuery setCachePolicy:kAVCachePolicyNetworkElseCache];
    [userQuery whereKey:@"objectId" equalTo:modelUser.objectId];
    NSArray *array =  [userQuery findObjects:&error];
    if (error) {
        block(nil, error);
    }
    LTModelUser *user = [array firstObject];
    post.userName = user.username;
    
    // 填充头像 url
    AVFile *avatarFile = user.avatar;
    post.avatarUrlString = [avatarFile getThumbnailURLWithScaleToFit:false width:60 height:60];
    
    /// 文字内容填充
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSRTFTextDocumentType};
    post.content = [[NSAttributedString alloc]initWithData:[model objectForKey:@"content"] options:options documentAttributes:nil error:nil].copy;

    /// 图片内容填充
    NSMutableDictionary *photoThumbUrls  = @{}.mutableCopy;
    for (int i = 0; i < model.photos.count; i++) {
        AVFile *photo = model.photos[i];
        // 这时候 photo 内部没有数据 得去查一遍
        AVQuery *query = [AVFile query];
        [query whereKey:@"objectId" equalTo:photo.objectId];
//        [query setCachePolicy:kAVCachePolicyNetworkElseCache];
        AVObject *fileObject = [[query findObjects:&error] firstObject];
        
        AVFile *file = [AVFile fileWithAVObject:fileObject];
        if (error) {
            block(nil, error);
        }
        NSString *thumbImageUrl = [file getThumbnailURLWithScaleToFit:NO width:300 height:300];
        [photoThumbUrls setObject:thumbImageUrl forKey:[NSString stringWithFormat:@"%d",i]];
        if(i == model.photos.count - 1 ){
            post.photoThumbUrls = photoThumbUrls.copy;
        }
    }
    /// 点赞用户填充
    NSMutableAttributedString *likedUsersAttributedString = [[NSMutableAttributedString alloc]init];
    for (int i = 0; i < model.likedUser.count; i++) {
        LTModelUser *modelUser = model.likedUser[i];
        AVQuery *userQuery = [AVQuery queryWithClassName:@"_User"];
//        [userQuery setCachePolicy:kAVCachePolicyNetworkElseCache];
        [userQuery whereKey:@"objectId" equalTo:modelUser.objectId];
        LTModelUser *user = [[userQuery findObjects:&error] firstObject];
        if (error) {
            block(nil, error);
        }
        [likedUsersAttributedString appendString:user.username];
        if (i == model.likedUser.count - 1) {
            post.likedUsersAttributedString = likedUsersAttributedString.copy;
            
        }
    }
    NSLog(@"加载了一个 post");
    block(post,error);
    
    
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
    
    [[cell.postView.rac_likeSignal takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(id x) {
        LTPostViewRoundButton *button = x;
        cell.postView.liked = !cell.postView.liked ;
        button.enabled = NO;/// 点击一次之后不允许点击了
        
//        LTPostmod *post = self.posts[indexPath.row];
//        BOOL needRemove = NO;// 标记需要移除还是添加
//        NSMutableArray *likedUsers = [[NSMutableArray alloc]initWithArray:post.likedUser];
//        for (LTModelUser *user in likedUsers) {
//            if([user.objectId isEqualToString:([LTModelUser currentUser].objectId)]){
//                [likedUsers removeObject:user];
//                needRemove = YES;
//                break;
//            }
//        }
//        
//        if (needRemove || likedUsers.count == 0) {
//            [likedUsers addObject:[LTModelUser currentUser]];
//        }
//        post.likedUser = likedUsers.copy;
//        [post saveEventually];

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
                               andPicCound:post.photoThumbUrls.count
                              andUsersName:[[NSAttributedString alloc]initWithString:post.userName]
                               andComments:post.comments
                            andCommitLimit:6
                            andCommentFold:NO
                          andPreferedWidth:[UIScreen mainScreen].bounds.size.width];

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    LTPostView *postView = ((LTPostViewCell *)cell).postView;
    LTPostModel *post = self.posts[indexPath.row];
    [postView.imagesView configViewWithPicNum:post.photoThumbUrls.count needBig:YES itemSpace:6 limit:9];
    postView.profileView.name = post.userName;
    postView.profileView.avatarUrlString = post.avatarUrlString;
    
    postView.contentView.content = post.content;
    postView.imagesView.photos = post.photoThumbUrls;
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
    __weak __typeof(self) weakSelf = self;
    [uploadAlert addAction:[UIAlertAction actionWithTitle:@"上传图片动态" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //[weakSelf loadMorePostList];
        [weakSelf.tableView reloadData];
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
