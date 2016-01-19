//
//  LTUserInfoFollowButton.h
//  OhShock
//
//  Created by Lintao.Yu on 15/12/15.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
static CGFloat const LTUserInfoFollowButtonHeight = 40;
static CGFloat const LTUserInfoFollowButtonWidth = 100;
/**
 *  关注按钮的显示效果
 *  notFollowType   显示关注
 *  bothFollowType  显示互相关注
 *  followedType    显示已关注
 */
typedef NS_ENUM(NSUInteger, LTUserInfoFollowButtonType) {
    /**
     *  @author Lintao Yu, 15-12-18 17:12:10
     *
     *  显示关注
     */
    notFollowType = 0,
    /**
     *  @author Lintao Yu, 15-12-18 17:12:10
     *
     *  显示互相关注
     */
    bothFollowType,
    /**
     *  @author Lintao Yu, 15-12-18 17:12:10
     *
     *  显示已关注
     */
    followedType
};
@interface LTUserInfoFollowButton : UIButton

@property (nonatomic, assign) LTUserInfoFollowButtonType type;
@end
