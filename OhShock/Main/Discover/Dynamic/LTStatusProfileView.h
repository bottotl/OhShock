//
//  LTStatusProfileView.h
//  LTDynamicCellDemo
//
//  Created by Lintao.Yu on 15/12/11.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYKit.h"
#import "WBStatusLayout.h"
@class LTStatusCell;
/**
 *  @author Lintao Yu, 15-12-11 19:12:46
 *
 *  用户资料
 */
@interface LTStatusProfileView : UIView
@property (nonatomic, strong) UIImageView *avatarView; ///< 头像
@property (nonatomic, strong) UIImageView *avatarBadgeView; ///< 徽章
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *sourceLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, assign) WBUserVerifyType verifyType;
@property (nonatomic, weak) LTStatusCell *cell;
@end
