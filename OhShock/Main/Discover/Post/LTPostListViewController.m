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
#import "LTModelPostComment+NSAttributedString.h"
#import "AVFile+Category.h"

static NSUInteger const onceLoadPostNum = 5;
@interface LTPostListViewController ()<UITableViewDelegate, UITableViewDataSource >

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
#pragma mark - === 网络相关数据 ===
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

-(void)p_addCommentPost:(LTModelPost *)post andContent:(NSString *)content fromUser:(LTModelUser *)fromUser toUser:(LTModelUser *)toUser block:(void(^)(LTModelPost *post, NSError *error))block {
    LTModelPostComment *comment = [LTModelPostComment new];
    comment.content = content;
    comment.toUser = toUser;
    comment.fromUser = fromUser;
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSMutableArray *comments;
            if(post.comments){
                comments = post.comments.mutableCopy;
            }else{
                comments = @[].mutableCopy;
            }
            
            [comments addObject:comment];
            post.comments = comments.copy;
            [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                block(post, error);
                if (succeeded) {
                    NSLog(@"添加评论成功");
                }else{
                    NSLog(@"添加评论失败:%@",error);
                }
            }];
        }else{
            NSLog(@"comment saveEventually 出错:%@",error);
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
        post.content = [self p_contentAttributedString:model.content];
        
        /// 图片内容填充
        post.picFiles = [AVFile fetchAll:model.photos error:&error];
        post.picThumbFiles = [AVFile fetchAll:model.thumbPhotos error:&error].mutableCopy;
        
        /// 点赞按钮设置
        NSMutableArray *likedUsers = [[NSMutableArray alloc]initWithArray:model.likedUser];
        for (LTModelUser *user in likedUsers) {
            if([user.objectId isEqualToString:([LTModelUser currentUser].objectId)]){
                post.liked = YES;
                break;
            }
        }
        
        /// 点赞用户填充
        post.likedUsersAttributedString = [self p_likedUsersAttributedString:model.likedUser];

        /// 评论内容填充
        post.comments = [self p_comments:model.comments];
        NSLog(@"加载了一个 post");
        block(post,error);
    });
    
}

-(void)p_likeButtonOnClick:(LTPostViewCell *)cell button:(UIButton *)button indexPath:(NSIndexPath *)indexPath{
    
    LTPostModel *model =  self.posts[[NSString stringWithFormat:@"%d",(int)indexPath.row]];
    
    button.enabled = NO;/// 点击一次之后不允许点击了
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
    // 先修改本地数据
    // 如果上传失败，把本地数据改回来、重新刷新列表
    model.likedUsersAttributedString = [self p_likedUsersAttributedString:post.likedUser];
    model.liked = !needRemove;
    [self.tableView reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
    @weakify(self);
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        @strongify(self);
        if (succeeded) {
            NSLog(@"成功修改 post");
            button.enabled = YES;
            [self.tableView reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
        }else{
            NSLog(@"post saveInBackgroundWithBlock 出错%@",error);
            model.liked = !model.liked;
            button.enabled = YES;
            [self.tableView reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
        }
    }];

}

//-(void)p_commentButtonOnClick:()

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    NSMutableDictionary *thumbPhotosDic = @{}.mutableCopy;
    for (int i = 0; i < post.picThumbFiles.count; i++) {
        [thumbPhotosDic setValue:post.picThumbFiles[i].url forKey:[NSString stringWithFormat:@"%d",i]];
    }
    postView.imagesView.thumbPhotos = thumbPhotosDic;
    
    NSMutableDictionary *bigPhotosDic = @{}.mutableCopy;
    for (int i = 0; i < post.picFiles.count; i++) {
        [bigPhotosDic setValue:post.picFiles[i].url forKey:[NSString stringWithFormat:@"%d",i]];
    }
    postView.imagesView.bigPhotos = bigPhotosDic;

    cell.loadedData = YES;
    
    
    cell.postView.liked = post.liked;
    cell.postView.likedView.usersName = post.likedUsersAttributedString;
    cell.postView.commentsView.comments = post.comments;
    
    /// 点赞按钮点击
    @weakify(self);
    [[cell.postView.rac_likeSignal takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(id x) {
        @strongify(self);
        [self p_likeButtonOnClick:cell button:x indexPath:indexPath];
    }];
    
    /// 评论按钮点击
    [[cell.postView.rac_commitSignal takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(id x){
        @strongify(self);
        LTModelPost *post = self.dataSource[indexPath.row];
        @weakify(self);
        /// 模拟假数据
        [self p_addCommentPost:post andContent:@"一首《求佛》成就了誓言，也让他独特的嗓音像曾经的刀郎一样铭刻在了无数歌迷心中。曾在2006年无线音乐咪咕汇上获得年度十大畅销金曲奖" fromUser:[LTModelUser currentUser] toUser:post.pubUser block:^(LTModelPost *post, NSError *error) {
            @strongify(self);
            if(post){
                self.dataSource[indexPath.row] = post;
                LTModelPostComment *modelPostComment = post.comments.lastObject;
                [((LTPostModel *)self.posts[[NSString stringWithFormat:@"%d",(int)indexPath.row]]).comments addObject:[modelPostComment toAttributedString]];
                @weakify(self);
                dispatch_async(dispatch_get_main_queue(), ^{
                    @strongify(self);
                    [self.tableView reloadData];
                });
            }
        }];
    }];
    
    
    return cell;
}

#pragma mark  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTPostModel *post = self.posts[[NSString stringWithFormat:@"%d",(int)indexPath.row]];
    CGFloat height = [LTPostView heightWithContent:post.content
                               andPicCound:post.picThumbFiles.count
                              andUsersName:post.likedUsersAttributedString
                               andComments:post.comments
                            andCommitLimit:6
                            andCommentFold:NO
                          andPreferedWidth:[UIScreen mainScreen].bounds.size.width];
    return height;

}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//#pragma mark LTPostImagesViewDelegate
//- (void)imagesView:(LTPostImagesView *)imagesView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    LTPostImageCollectionViewCell *cell = (LTPostImageCollectionViewCell *)[imagesView cellForItemAtIndexPath:indexPath];
//
//    NSMutableArray *items = @[].mutableCopy;
//    NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:0];
//    for (NSUInteger i = 0 ; self.posts; i++) {
//        LTPostImageCollectionViewCell *cell = (LTPostImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:index];
//        LTPostImageModel *pic = self.data[index.row];
//        [cell configCellWithImageUrl:pic.smallUrlString];
//        
//        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
//        item.thumbView = cell.imageView;
//        item.largeImageURL = [NSURL URLWithString:((LTPostImageModel *)self.data[index.row]).bigUrlString];
//        item.largeImageSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
//        [items addObject:item];
//        index = [NSIndexPath indexPathForRow:(index.row + 1) inSection:0];;
//    }
//    UINavigationController * viewController = [self theNavi];
//    
//    NSLog(@"%@",[NSValue valueWithCGRect:[self convertRect:cell.frame toView:viewController.view]]) ;
//    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
//    [v presentFromView:self andFromItemIndex:indexPath.row andCellView:cell toContainer:viewController.view animated:YES completion:nil];
//}

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
    }]];
    [self.uploadAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        self.uploadAlert = nil;
    }]];
    [self presentViewController:self.uploadAlert animated:YES completion:nil];
}

#pragma mark - === 工具 ===
/// 单个点赞用户名富文本
-(NSAttributedString *)p_likedUserAttributedString:(LTModelUser *)user{
    UIFont *likedUsersfont = [UIFont systemFontOfSize:16];
    NSAttributedString *usernameText = [[NSAttributedString alloc] initWithString:user.username attributes:@{NSFontAttributeName : likedUsersfont, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"446889"], NSParagraphStyleAttributeName : [NSMutableParagraphStyle new]}];
    return usernameText;
}
/// 总的点赞列表富文本
-(NSAttributedString *)p_likedUsersAttributedString:(NSArray <LTModelUser *> *)users{
    if(!users||users.count == 0){
        return nil;
    }
    [AVObject fetchAllIfNeeded:users];
    NSMutableAttributedString *likedUsersAttributedString = [[NSMutableAttributedString alloc]init];
    
    UIFont *likedUsersfont = [UIFont systemFontOfSize:16];
    UIImage *image = [UIImage imageNamed:@"post_like_selected_btn"];// 点赞头图
    image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationUp];
    NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:likedUsersfont alignment:YYTextVerticalAlignmentCenter];
    [likedUsersAttributedString appendAttributedString:attachText];
    
    for (int i = 0; i < users.count; i++) {
        [likedUsersAttributedString appendAttributedString:[self p_likedUserAttributedString:users[i]]];
        if (i != users.count - 1) {
            [likedUsersAttributedString appendString:@","];
        }
    }
    return likedUsersAttributedString;
    
}

-(NSAttributedString *)p_contentAttributedString:(NSData *)content{
    if (content) {
        NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSRTFTextDocumentType};
        return [[NSAttributedString alloc]initWithData:content options:options documentAttributes:nil error:nil].copy;
    }
    return nil;
}

/// 所有的评论
-(NSMutableArray <NSAttributedString *> *)p_comments:(NSArray <LTModelPostComment *> *)comments{
    [AVObject fetchAllIfNeeded:comments];
    NSMutableArray <NSAttributedString *>* p_comments = @[].mutableCopy;
    for (LTModelPostComment *comment in comments) {
        [p_comments addObject:[comment toAttributedString]];
    }
    return p_comments;
}

@end
