//
//  LTMeHeadUserFollowerAndFolloweeView.h
//  OhShock
//
//  Created by Lintao.Yu on 12/9/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  @author Lintao Yu, 15-12-09 12:12:38
 *
 *  展示粉丝和关注数量
 */
@interface LTMeHeadUserFollowerAndFolloweeView : UIView
/// 关注数量
@property (nonatomic, assign) NSInteger followeeNum;
/// 粉丝数量
@property (nonatomic, assign) NSInteger followerNum;

@end
