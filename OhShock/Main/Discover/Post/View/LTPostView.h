//
//  LTPostView.h
//  OhShock
//
//  Created by Lintao.Yu on 1/8/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LTPostModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "LTPostProfileView.h"
#import "LTPostContentView.h"
#import "LTPostImagesView.h"
#import "LTPostLikedView.h"
#import "LTPostCommentView.h"
#import "LTPostViewRoundButton.h"

/**
 *  动态 View 页面
    主要负责把零碎的其他小页面、按钮组合在一起
 */
@interface LTPostView : UIView

@property (nonatomic, strong) LTPostModel *data;

@property (nonatomic,strong) RACSignal *rac_gestureSignal;

@property (nonatomic, strong) LTPostProfileView *profileView;

@property (nonatomic, strong) LTPostContentView *contentView;

@property (nonatomic, strong) LTPostImagesView *imagesView;

@property (nonatomic, strong) LTPostViewRoundButton *commitButton;

@property (nonatomic, strong) LTPostViewRoundButton *likeButton;

@property (nonatomic, strong) LTPostLikedView *likedView;

@property (nonatomic, strong) LTPostCommentView *commentsView;


+(CGFloat) viewHeightWithData:(LTPostModel *)data;

@end