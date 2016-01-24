//
//  LTPostView.m
//  OhShock
//
//  Created by Lintao.Yu on 1/8/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import "LTPostView.h"
#import "UIView+Layout.h"
#import "UIImage+Common.h"
#import "LTPostImageCollectionViewCell.h"
#import "YYPhotoGroupView.h"

static CGFloat const LTPostContentLeftPadding = 5;
static CGFloat const LTPostContentRightPadding = 3;
static CGFloat const LTPostButtonHeight = 20;// 点赞、评论按钮的高度
static CGFloat const LTPostLikedViewLeftPadding = 10;// 点赞列表左边距
static CGFloat const LTPostLikedViewRightPadding = 10;// 点赞列表右边距

@interface LTPostView ()<UICollectionViewDelegate>

@property (nonatomic, strong) LTPostViewRoundButton *commitButton;

@property (nonatomic, strong) LTPostViewRoundButton *likeButton;
@end

@implementation LTPostView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.liked = NO;
    }
    return self;
}

#pragma mark - 高度计算
+ (CGFloat)heightWithContent:(NSAttributedString *)content andPicCound:(NSInteger)picCount andUsersName:(NSAttributedString *)usersName andComments:(NSArray<NSAttributedString *> *)comments andCommitLimit:(NSInteger)limit andCommentFold:(BOOL)commentFold andPreferedWidth:(CGFloat)width{
    CGFloat height = 0;
    CGFloat offset = 0;
    height += [LTPostProfileView viewHeight];
    height += [LTPostContentView heightWithContent:content andPreferedWidth:width];
    height += [LTPostImagesView heightWithSuggestThreePicWidth:(([UIScreen mainScreen].bounds.size.width) - LTPostContentLeftPadding - LTPostContentRightPadding )
                                                   andPicCount:picCount
                                                     andBigPic:YES
                                                  andItemSpace:6
                                                     withLimit:9];
    offset = 20;
    height += (LTPostButtonHeight +offset);
    offset = 5;
    height += ([LTPostLikedView heightWithUsersName:usersName andWith:(([UIScreen mainScreen].bounds.size.width) -LTPostLikedViewLeftPadding - LTPostLikedViewRightPadding)] +offset);
    offset = 0;
    height += ([LTPostCommentView heightWithComments:comments andLimit:limit andFold:commentFold withWidth:(([UIScreen mainScreen].bounds.size.width) -LTPostLikedViewLeftPadding - LTPostLikedViewRightPadding)] + offset);
    return height;
}

#pragma mark - layout
/**
 *  和 viewHeightWithData 的内容息息相关
 */
-(void)layoutSubviews{
    [super layoutSubviews];
    /**
     *  offset 标记了竖直方向上控件之间的间距
     */
    CGFloat offset ;
    self.profileView.width = self.width;
    self.profileView.top = 0;
    self.profileView.left = 0;
    
    self.contentView.width = self.width - LTPostContentLeftPadding - LTPostContentRightPadding;
    [self.contentView sizeToFit];
    self.contentView.top= self.profileView.bottom;
    self.contentView.left = LTPostContentLeftPadding;
    
    self.imagesView.width = (([UIScreen mainScreen].bounds.size.width) - LTPostContentLeftPadding - LTPostContentRightPadding );
    [self.imagesView sizeToFit];
    self.imagesView.top = self.contentView.bottom;
    self.imagesView.left = 0;
    
    
    offset = 20;
    CGFloat buttonRightPadding = 20;// 距离右边的距离
    self.commitButton.right = self.width - buttonRightPadding;
    self.commitButton.top = self.imagesView.bottom + offset;
    
    CGFloat buttonPadding = 16;// 按钮间距
    self.likeButton.right = self.commitButton.left - buttonPadding;
    self.likeButton.top = self.imagesView.bottom + offset;
    
    
    offset = 5;
    self.likedView.width = self.width - LTPostLikedViewLeftPadding - LTPostLikedViewRightPadding;
    [self.likedView sizeToFit];
    self.likedView.top = self.likeButton.bottom + offset;
    self.likedView.left = LTPostLikedViewLeftPadding;
    
    offset = 0;
    self.commentsView.width = self.width - LTPostLikedViewLeftPadding - LTPostLikedViewRightPadding;
    [self.commentsView sizeToFit];
    [self.commentsView resetTabelView];
    self.commentsView.top = self.likedView.bottom + offset;
    self.commentsView.left = LTPostLikedViewLeftPadding;

}

#pragma mark - collection view delegate
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSMutableArray *items = @[].mutableCopy;
//    LTPostImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LTPostImageCollectionCellIdentifier forIndexPath:indexPath];
//    LTPostImageModel *pic = self.data.pic[indexPath.row];
//    [cell configCellWithImageUrl:pic.smallUrlString];
//    for (LTPostImageModel *model in self.data.pic) {
//        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
//        item.thumbView = cell.imageView;
//        item.largeImageURL = [NSURL URLWithString:model.bigUrlString];
//        item.largeImageSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
//        [items addObject:item];
//    }
//    NSLog(@"点击了图片");
//    UINavigationController * viewController = (UINavigationController *)((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController;
////    UIViewController * viewController = (UINavigationController *)((UINavigationController *)(((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController)).topViewController;
////    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items.copy];
////    [v presentFromImageView:cell.imageView toContainer:viewController.view animated:YES completion:nil];
//    NSLog(@"%@",[NSValue valueWithCGRect:[cell.imageView convertRect:cell.imageView.frame toView:viewController.view]]) ;
//}

#pragma mark - property
#pragma mark 点赞
-(void)setLiked:(BOOL)liked{
    _liked = liked;
    if(liked){//设置为点过赞状态
        [self.likeButton setImage:[[UIImage imageNamed:@"post_like_selected_btn"]scaledToSize:CGSizeMake(20, 20) ] forState:UIControlStateNormal];
    }else{
        [self.likeButton setImage:[[UIImage imageNamed:@"post_like_normal_btn"]scaledToSize:CGSizeMake(20, 20) ] forState:UIControlStateNormal];
    }
}
#pragma mark View
-(LTPostImagesView *)imagesView{
    if (!_imagesView) {
        _imagesView = [LTPostImagesView new];

        //_imagesView.collectionView.delegate = self;
        [self addSubview:_imagesView];
    }
    return _imagesView;
}

-(LTPostContentView *)contentView{
    if (!_contentView) {
        _contentView = [LTPostContentView new];
        [self addSubview:_contentView];
    }
    return _contentView;
}

-(LTPostProfileView *)profileView{
    if (!_profileView) {
        _profileView = [LTPostProfileView new];
        [self addSubview:_profileView];
    }
    return _profileView;
}

-(LTPostViewRoundButton *)likeButton{
    if (!_likeButton) {
        _likeButton = [[LTPostViewRoundButton alloc]initWithFrame:CGRectMake(0, 0, 45, LTPostButtonHeight)];
        [_likeButton setTitle:@"点赞" forState:UIControlStateNormal];
        [self addSubview:_likeButton];
    }
    return _likeButton;
}

-(LTPostViewRoundButton *)commitButton{
    if (!_commitButton) {
        _commitButton = [[LTPostViewRoundButton alloc]initWithFrame:CGRectMake(0, 0, 45, LTPostButtonHeight)];
        [_commitButton setTitle:@"评论" forState:UIControlStateNormal];
        [_commitButton setImage:[[UIImage imageNamed:@"post_comment_btn"]scaledToSize:CGSizeMake(20, 20) ] forState:UIControlStateNormal];
        [self addSubview:_commitButton];
    }
    return _commitButton;
}

-(LTPostLikedView *)likedView{
    if (!_likedView) {
        _likedView = [[LTPostLikedView alloc]initWithFrame:CGRectMake(0, 0, LTPostLikedViewRightPadding, 0)];
        [self addSubview:_likedView];
    }
    return _likedView;
}

-(LTPostCommentView *)commentsView{
    if (!_commentsView) {
        _commentsView = [LTPostCommentView new];
        [self addSubview:_commentsView];
    }
    return _commentsView;
}

-(RACSignal *)rac_likeSignal{
    return [self.likeButton rac_signalForControlEvents:UIControlEventTouchUpInside];
}

-(RACSignal *)rac_commitSignal{
    return [self.commitButton rac_signalForControlEvents:UIControlEventTouchUpInside];
}

@end
