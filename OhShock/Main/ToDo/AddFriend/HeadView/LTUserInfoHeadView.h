//
//  LTUserInfoHeadView.h
//  OhShock
//
//  Created by Lintao.Yu on 15/12/15.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveCocoa.h"
#import "UIView+Layout.h"
#import "LTMeHeadUserImageView.h"
#import "LTMeHeadUserInfoView.h"
#import "LTUserInfoFollowButton.h"
#import "UIImageView+WebCache.h"
#import "LTMeHeadUserFollowerAndFolloweeView.h"
static CGFloat LTUserInfoHeadViewHeight = 300;
//@protocol LTUserInfoHeadDelegate ;
/**
 *  @author Lintao Yu, 15-12-15 16:12:10
 *
 *  显示其他用户信息 的头部
 *  这个控件和 UIScrollView+APParallaxHeader 搭配使用时会不断修改自身的高度（进行伸缩变换）
 *  在布局的时候需要相对于这个控件的底部进行布局
 */
@interface LTUserInfoHeadView : UIImageView
/// 头像对应的 URL
@property (nonatomic, copy) NSString *avatorUrlString;
/**
 *  关注按钮的显示种类
 *
 *  显示关注    notFollowType
 *
 *  显示互相关注 bothFollowType
 *
 *  显示已关注   followedType
 */
@property (nonatomic, assign) LTUserInfoFollowButtonType followButoonType;
/// 头像
@property (nonatomic, strong) LTMeHeadUserImageView *userAvator;
/// 用户信息
@property (nonatomic, strong) LTMeHeadUserInfoView *userInfo;
/// 关注信息
@property (nonatomic, strong) LTMeHeadUserFollowerAndFolloweeView *followInfoView;
/// 关注按钮
@property (nonatomic, strong) LTUserInfoFollowButton *followButton;
-(RACSignal *)rac_avatorTapGesture;
-(RACSignal *)rac_followeeTapGesture;
-(RACSignal *)rac_followerTapGesture;
-(RACSignal *)rac_followButtonOnClick;
@end
