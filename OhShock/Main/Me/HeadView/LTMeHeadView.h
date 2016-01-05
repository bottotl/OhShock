//
//  LTMeHeadView.h
//  OhShock
//
//  Created by Lintao.Yu on 12/8/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIView+Layout.h"
#import "LTMeHeadUserImageView.h"
#import "LTMeHeadUserInfoView.h"
#import "UIImageView+WebCache.h"
#import "LTMeHeadUserFollowerAndFolloweeView.h"

static CGFloat const LTMeHeadViewHeight = 250;
@protocol LTMeHeadDelegate;
/**
 *  @author Lintao Yu, 15-12-08 14:12:51
 *
 *  “我”页面的头部
 *  这个控件和 UIScrollView+APParallaxHeader 搭配使用时会不断修改自身的高度（进行伸缩变换）
    所以在布局的时候需要相对于这个控件的底部进行布局
 */
@interface LTMeHeadView : UIImageView
/// 头像对应的 URL
@property (nonatomic, copy) NSString *avatorUrlString;
@property (nonatomic, weak) id<LTMeHeadDelegate> delegate;
@property (nonatomic, strong) LTMeHeadUserImageView *userAvator;
@property (nonatomic, strong) LTMeHeadUserInfoView *userInfo;
@property (nonatomic, strong) LTMeHeadUserFollowerAndFolloweeView *followInfoView;
@property (nonatomic, copy) NSString *userName;
-(RACSignal *)rac_avatorTapGesture;
-(RACSignal *)rac_followeeTapGesture;
-(RACSignal *)rac_followerTapGesture;
@end

@protocol LTMeHeadDelegate <NSObject>
@optional
-(void)avatorOnClick;
-(void)backgroundImageOnClick;
@end