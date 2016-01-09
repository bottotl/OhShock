//
//  LTPostView.m
//  OhShock
//
//  Created by Lintao.Yu on 1/8/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import "LTPostView.h"
#import "LTPostProfileView.h"
#import "LTPostContentView.h"
#import "LTPostImagesView.h"
#import "LTPostLikedView.h"
#import "LTPostCommitsView.h"
#import "LTPostViewRoundButton.h"
#import "UIView+Layout.h"
#import "UIImage+Common.h"

static CGFloat const LTPostContentLeftPadding = 5;
static CGFloat const LTPostContentRightPadding = 3;
static CGFloat const LTPostButtonHeight = 20;// 点赞、评论按钮的高度
static CGFloat const LTPostLikedViewLeftPadding = 10;// 点赞列表左边距
static CGFloat const LTPostLikedViewRightPadding = 10;// 点赞列表右边距

@interface LTPostView ()

@property (nonatomic, strong) LTPostProfileView *profileView;

@property (nonatomic, strong) LTPostContentView *contentView;

@property (nonatomic, strong) LTPostImagesView *imagesView;

@property (nonatomic, strong) LTPostViewRoundButton *commitButton;

@property (nonatomic, strong) LTPostViewRoundButton *likeButton;

@property (nonatomic, strong) LTPostLikedView *likedView;

@property (nonatomic, strong) LTPostCommitsView *commitsView;


@end

@implementation LTPostView

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat offset ;
    self.profileView.width = self.width;
    self.profileView.top = 0;
    self.profileView.left = 0;
    
    self.contentView.width = self.width - LTPostContentLeftPadding - LTPostContentRightPadding;
    [self.contentView sizeToFit];
    self.contentView.top= self.profileView.bottom;
    self.contentView.left = LTPostContentLeftPadding;
    
    self.imagesView.width = self.width;
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
    
    
    offset = 13;
    self.likedView.width = self.width - LTPostLikedViewLeftPadding - LTPostLikedViewRightPadding;
    [self.likedView sizeToFit];
    self.likedView.top = self.likeButton.bottom + offset;
    self.likedView.left = LTPostLikedViewLeftPadding;
    
    offset = 3;
    self.commitsView.width = self.width - LTPostLikedViewLeftPadding - LTPostLikedViewRightPadding;
    [self.commitsView sizeToFit];
    self.commitsView.top = self.likedView.bottom +offset;
    self.commitsView.left = LTPostLikedViewLeftPadding;

}


#pragma mark - property

#pragma mark Data
-(void)setData:(LTPostModel *)data{
    //_data = data;
    
    self.profileView.data = data.profileData;
    self.contentView.data = data.contentData;
    
    self.imagesView.data = data.pic;
    self.imagesView.limit = 9;
    self.imagesView.hidden = NO;
    self.imagesView.itemSpace = 6;
    self.imagesView.needBig = YES;
    
    self.likedView.data = data.likedData;
    
    [self.commitsView configWithData:data.commitsData];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

#pragma mark View
-(LTPostImagesView *)imagesView{
    if (!_imagesView) {
        _imagesView = [LTPostImagesView new];
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
        [_likeButton setImage:[[UIImage imageNamed:@"post_like_selected_btn"]scaledToSize:CGSizeMake(20, 20) ] forState:UIControlStateNormal];
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

-(LTPostCommitsView *)commitsView{
    if (!_commitsView) {
        _commitsView = [LTPostCommitsView new];
        [self addSubview:_commitsView];
    }
    return _commitsView;
}

#pragma mark - 高度计算

+(CGFloat)viewHeightWithData:(LTPostModel *)data{
    CGFloat height = 0;
    CGFloat offset;
    height += [LTPostProfileView viewHeight];
    height += [LTPostContentView viewHeightWithContent:data.contentData.content andPerferedWidth:[UIScreen mainScreen].bounds.size.width];
    height += [LTPostImagesView heightWithSuggestThreePicWidth:(([UIScreen mainScreen].bounds.size.width) - LTPostContentLeftPadding - LTPostContentRightPadding )
                                                   andPicCount:data.pic.count
                                                     andBigPic:YES
                                                  andItemSpace:6
                                                     withLimit:9];
    offset = 20;
    height += (LTPostButtonHeight +offset);
    
    offset = 13;
    height += [LTPostLikedView heightWithUsersName:data.likedData.usersNameAttributedString andWith:(([UIScreen mainScreen].bounds.size.width) -LTPostLikedViewLeftPadding - LTPostLikedViewRightPadding)];
    height += [LTPostCommitsView heightWithData:data.commitsData andWidth:(([UIScreen mainScreen].bounds.size.width) -LTPostLikedViewLeftPadding - LTPostLikedViewRightPadding)];
    return height + 10 */** 竖直方向上 YYLabel 的数量 + 1*/4;
}


@end
