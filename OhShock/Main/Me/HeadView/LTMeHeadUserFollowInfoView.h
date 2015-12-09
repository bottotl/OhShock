//
//  LTMeHeadUserFollowInfoView.h
//  OhShock
//
//  Created by Lintao.Yu on 12/9/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat LTMeHeadUserFollowInfoViewHeight = 30;
static CGFloat LTMeHeadUserFollowInfoViewWidth = 80;

/**
 *  @author Lintao Yu, 15-12-09 12:12:01
 *
 *  展示粉丝或者关注的数量的基础控件
 */
@interface LTMeHeadUserFollowInfoView : UIView
/// 数量
@property (nonatomic, assign) NSInteger num;
/// 展示信息
@property (nonatomic, copy) NSString *info;

@end
