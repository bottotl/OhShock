//
//  LTPostView.h
//  OhShock
//
//  Created by Lintao.Yu on 1/8/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LTPostProfileView.h"
#import "LTPostContentView.h"
#import "LTPostImagesView.h"
#import "LTPostLikedView.h"
#import "LTPostCommentView.h"
#import "LTPostViewRoundButton.h"

@class LTPostViewModel;

/**
 *  动态 View 页面
    主要负责把零碎的其他小页面、按钮组合在一起
 */
@interface LTPostView : UIView

@property (nonatomic, strong) LTPostProfileView *profileView;   ///< 个人信息

@property (nonatomic, strong) LTPostContentView *contentView;   ///< 文字内容

@property (nonatomic, strong) LTPostImagesView  *imagesView;    ///< 多图展示

@property (nonatomic, strong) LTPostLikedView   *likedView;     ///< 点赞用户

@property (nonatomic, strong) LTPostCommentView *commentsView;  ///< 评论列表

@property (nonatomic, assign) BOOL liked;///< 是否点过赞

/// signal
-(RACSignal *)rac_likeSignal;///< 点赞按钮点击
-(RACSignal *)rac_commitSignal;///< 评论按钮点击

+(CGFloat)heightWithContent:(NSAttributedString *)content andPicCound:(NSInteger)picCount andUsersName:(NSAttributedString *)usersName andComments:(NSArray<NSAttributedString *> *)comments andCommitLimit:(NSInteger)limit andCommentFold:(BOOL)commentFold andPreferedWidth:(CGFloat)width;
@end
