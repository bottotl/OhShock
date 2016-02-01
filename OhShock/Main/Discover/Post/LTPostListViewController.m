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



static NSUInteger const onceLoadPostNum = 1;
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
        
        /// 评论内容填充
        NSMutableArray *comments = @[].mutableCopy;
        [AVObject fetchAll:model.comments];
        for (LTModelPostComment *comment in model.comments) {
            
            [AVObject fetchAll:@[comment.toUser,comment.fromUser]];
            NSString *fromUserName = comment.fromUser.username;
            NSString *toUserName = comment.toUser.username;
            
            NSString *commentContent = comment.content;
            
            NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
            NSMutableAttributedString *text = [NSMutableAttributedString new];
            if (fromUserName.length) {
                NSAttributedString *fromUser = [[NSAttributedString alloc] initWithString:fromUserName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"446889"], NSParagraphStyleAttributeName : style}];
                [text appendAttributedString:fromUser];
            }
            if (toUserName.length) {
                NSAttributedString *returnKey = [[NSAttributedString alloc] initWithString:@"回复" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"], NSParagraphStyleAttributeName : style}];
                [text appendAttributedString:returnKey];
                
                NSAttributedString *toUser = [[NSAttributedString alloc] initWithString:toUserName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"446889"], NSParagraphStyleAttributeName : style}];
//                _toUserRange = NSMakeRange(self.fromUserRange.length + 2, comment.toUser.userName.length);
                [text appendAttributedString:toUser];
            }
            if (commentContent.length) {
                [text appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@":%@",commentContent] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"], NSParagraphStyleAttributeName : style}]];
            }
            [comments addObject:text];
        }
        
        post.comments = comments;
        NSLog(@"加载了一个 post");
        block(post,error);
    });
    
}
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
    NSMutableDictionary *dic = @{}.mutableCopy;
    for (int i = 0; i < post.picThumbFiles.count; i++) {
        [dic setValue:post.picThumbFiles[i].url forKey:[NSString stringWithFormat:@"%d",i]];
    }
    postView.imagesView.photos = dic;
    cell.loadedData = YES;
    
    
    cell.postView.liked = post.liked;
    
    cell.postView.commentsView.comments = post.comments;
    /// 点赞按钮点击
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
                ((LTPostModel *)self.posts[[NSString stringWithFormat:@"%d",(int)indexPath.row]]).liked = !needRemove;
                cell.postView.liked = !needRemove ;
                button.enabled = YES;
            }
        }];

    }];
    
    /// 评论按钮点击
    [[cell.postView.rac_commitSignal takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(id x){
        @strongify(self);
        LTModelPost *post = self.dataSource[indexPath.row];
        @weakify(self);
        [self p_addCommentPost:post andContent:@"我是英雄" fromUser:[LTModelUser currentUser] toUser:post.pubUser block:^(LTModelPost *post, NSError *error) {
            @strongify(self);
            if(post){
                self.dataSource[indexPath.row] = post;
                LTModelPostComment *modelPostComment  = post.comments.lastObject;
                [AVObject fetchAll:@[modelPostComment.toUser,modelPostComment.fromUser]];
                NSString *fromUserName = modelPostComment.fromUser.username;
                NSString *toUserName = modelPostComment.toUser.username;
                NSString *commentContent = modelPostComment.content;
                
                NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
                NSMutableAttributedString *text = [NSMutableAttributedString new];
                if (fromUserName.length) {
                    NSAttributedString *fromUser = [[NSAttributedString alloc] initWithString:fromUserName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"446889"], NSParagraphStyleAttributeName : style}];
                    [text appendAttributedString:fromUser];
                }
                if (toUserName.length) {
                    NSAttributedString *returnKey = [[NSAttributedString alloc] initWithString:@"回复" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"], NSParagraphStyleAttributeName : style}];
                    [text appendAttributedString:returnKey];
                    
                    NSAttributedString *toUser = [[NSAttributedString alloc] initWithString:toUserName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"446889"], NSParagraphStyleAttributeName : style}];
                    //                _toUserRange = NSMakeRange(self.fromUserRange.length + 2, comment.toUser.userName.length);
                    [text appendAttributedString:toUser];
                }
                if (commentContent.length) {
                    [text appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@":%@",commentContent] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"], NSParagraphStyleAttributeName : style}]];
                }

                
                [((LTPostModel *)self.posts[[NSString stringWithFormat:@"%d",(int)indexPath.row]]).comments addObject:text.copy];
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
                              andUsersName:[[NSAttributedString alloc]initWithString:post.userName]
                               andComments:post.comments
                            andCommitLimit:6
                            andCommentFold:NO
                          andPreferedWidth:[UIScreen mainScreen].bounds.size.width];
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
    }]];
    [self.uploadAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        self.uploadAlert = nil;
    }]];
    [self presentViewController:self.uploadAlert animated:YES completion:nil];
}

#pragma mark -
//- ()
@end
