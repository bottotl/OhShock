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
#import "JSQMessagesInputToolbar.h"


static NSUInteger const onceLoadPostNum = 10;
@interface LTPostListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) JSQMessagesInputToolbar *inputToolbar;

@property (nonatomic, strong) UITableView *tableView;

/// < NSNumber *> *
//@property (nonatomic, strong) NSMutableArray *heights;

//@property (nonatomic, strong) LTPostListService *service;
/// @{ int :LTPostModel * }
@property (nonatomic, strong) NSMutableDictionary *posts;

@property (nonatomic, assign) NSUInteger lastPostCount;
@property (nonatomic, strong) UIAlertController *uploadAlert;

/// LTPostModel
@property (nonatomic, strong) NSMutableArray <LTModelPost *> *dataSource;


@end

@implementation LTPostListViewController

#pragma mark - === View Life Cycle ===
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    _service = [LTPostListService new];
    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    [self.view addSubview:_tableView];
    
    _tableView.frame = self.view.bounds;
    [_tableView registerClass:[LTPostViewCell class] forCellReuseIdentifier:LTPostViewCellIdentifier];
    
//    _inputToolbar = [[JSQMessagesInputToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 80)];
//    [self.view addSubview:_inputToolbar];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camer_add_post"] style:UIBarButtonItemStylePlain target:self action:@selector(showPostItems)];
    rightItem.tintColor = UIColorHex(fd8224);
    self.navigationItem.rightBarButtonItem = rightItem;
    [self loadMorePostList];
    
    
}

#pragma mark === property ===
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}
-(NSMutableDictionary *)posts{
    if(!_posts){
        _posts = @{}.mutableCopy;
    }
    return _posts;
}
-(NSUInteger)lastPostCount{
    return self.dataSource.count;
}
#pragma mark - === 数据 ===
// 加载一次 post
-(void)loadMorePostList{
    AVQuery *query = [LTModelPost query];
    [query orderByDescending:@"createdAt"];
    query.skip = self.lastPostCount ;
    query.limit = onceLoadPostNum;
    [query setCachePolicy:kAVCachePolicyNetworkElseCache];
    @weakify(self);
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }else{
            NSMutableDictionary *onceLoadPosts = @{}.mutableCopy;
            
            for (int i = 0; i < objects.count; i ++) {
                LTModelPost *model = objects[i];
                [self p_dequePostFromModel:model block:^(LTPostModel *post, NSError *error) {
                    if (!error) {
                        @strongify(self);
                        [onceLoadPosts setObject:post forKey:[NSString stringWithFormat:@"%d",(int)(i + self.lastPostCount)]];
                        if (onceLoadPosts.count == objects.count) {
                            [self.posts addEntriesFromDictionary:onceLoadPosts];
                            [self.dataSource addObjectsFromArray:objects];
                            NSLog(@"post 加载完成");
                            @weakify(self);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                @strongify(self);
                                [self.tableView reloadData];
                            });
                            
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
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
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
        if([model objectForKey:@"content"]){
           post.content = [[NSAttributedString alloc]initWithData:[model objectForKey:@"content"] options:options documentAttributes:nil error:nil].copy;
        }
        
        
        /// 图片内容填充
        post.picFiles = model.photos.copy;
        post.picThumbFiles = @[].mutableCopy;
        for (int i = 0; i < model.thumbPhotos.count; i++) {
            AVFile *thumbPhoto = model.thumbPhotos[i];
            // 这时候 photo 内部没有数据 得去查一遍
            AVQuery *query = [AVFile query];
            [query setCachePolicy:kAVCachePolicyCacheElseNetwork];
            AVFile *file = [AVFile fileWithAVObject:[query getObjectWithId:thumbPhoto.objectId]];
            [post.picThumbFiles addObject:file];
            
        }
        /// 点赞按钮设置
        NSMutableArray *likedUsers = [[NSMutableArray alloc]initWithArray:model.likedUser];
        for (LTModelUser *user in likedUsers) {
            if([user.objectId isEqualToString:([LTModelUser currentUser].objectId)]){
                post.liked = YES;
                break;
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
    });
    
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
    NSLog(@"numberOfRowsInSection = %lu",self.posts.count);
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTPostViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LTPostViewCellIdentifier forIndexPath:indexPath];
    LTPostView *postView = cell.postView;
    LTPostModel *post = self.posts[[NSString stringWithFormat:@"%d",(int)indexPath.row]];
    [postView.imagesView configViewWithPicNum:post.picFiles.count needBig:YES itemSpace:6 limit:9];
    postView.profileView.name = post.userName;
    postView.profileView.avatarUrlString = post.avatarUrlString;
    
    postView.contentView.content = post.content;
    NSMutableDictionary *dic = @{}.mutableCopy;
    for (int i = 0; i < post.picThumbFiles.count; i++) {
        [dic setValue:post.picThumbFiles[i].url forKey:[NSString stringWithFormat:@"%d",i]];
    }
    postView.imagesView.photos = dic;
    cell.loadedData = YES;
    cell.postView.liked = post.liked;
    
    @weakify(self);
    [[cell.postView.rac_likeSignal takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(id x) {
        LTPostViewRoundButton *button = x;
        button.enabled = NO;/// 点击一次之后不允许点击了
        @strongify(self);
        LTModelPost *post = self.dataSource[indexPath.row];
        BOOL needRemove = NO;// NO： 点赞 ,Yes：取消点赞
        NSMutableArray *likedUsers = [[NSMutableArray alloc]initWithArray:post.likedUser];
        for (LTModelUser *user in likedUsers) {
            if([user.objectId isEqualToString:([LTModelUser currentUser].objectId)]){
                needRemove = YES;
                // 取消点赞
                [likedUsers removeObject:user];
                
                break;
            }
        }
        
        if (!needRemove) {
            // 点赞
            [likedUsers addObject:[LTModelUser currentUser]];
        }
        post.likedUser = likedUsers.copy;
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"成功修改 post");
                cell.postView.liked = !needRemove ;
                button.enabled = YES;
            }
        }];

    }];
    [[cell.postView.rac_commitSignal takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(id x){
        NSLog(@"评论 %@",x);
    }];
    return cell;
}

#pragma mark  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTPostModel *post = self.posts[[NSString stringWithFormat:@"%d",(int)indexPath.row]];
    NSLog(@"算高");
    CGFloat height = [LTPostView heightWithContent:post.content
                               andPicCound:post.picThumbFiles.count
                              andUsersName:[[NSAttributedString alloc]initWithString:post.userName]
                               andComments:post.comments
                            andCommitLimit:6
                            andCommentFold:NO
                          andPreferedWidth:[UIScreen mainScreen].bounds.size.width];
    NSLog(@"end heightForRowAtIndexPath ");
    return height;

}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


#pragma mark - 上传事件

#pragma mark 按钮点击
- (void)showPostItems{
    self.uploadAlert = [UIAlertController alertControllerWithTitle:@"上传动态" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    @weakify(self);
    [self.uploadAlert addAction:[UIAlertAction actionWithTitle:@"上传图片动态" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        @strongify(self);
        self.uploadAlert = nil;
        [self loadMorePostList];
        [self.tableView reloadData];
    }]];
    [self.uploadAlert addAction:[UIAlertAction actionWithTitle:@"上传日程动态" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.uploadAlert = nil;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[LTUploadPhotosViewController new]];
        [self presentViewController:navi animated:YES completion:nil];
        NSLog(@"上传图片动态");
    }]];
    [self.uploadAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        self.uploadAlert = nil;
    }]];
    [self presentViewController:self.uploadAlert animated:YES completion:nil];
}

#pragma mark -
//- ()
@end
