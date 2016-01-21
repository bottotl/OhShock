//
//  LTPostProfileView.h
//  OhShock
//
//  Created by Lintao.Yu on 16/1/5.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
/// 头像的大小
static CGFloat const LTPostProfileViewAvatarViewHeight = 45;
/**
 *  显示个人信息
 */
@interface LTPostProfileView : UIView
/**
 *  用户名
 */
@property (nonatomic, copy) NSString *name;
/**
 *  头像缩略图展示控件
 */
@property (nonatomic, strong) UIImageView  *avatarView;

/**
 *  头像点击信号
 */
@property (nonatomic,strong) RACSignal *rac_gestureSignal;

/** 获取总高度*/
+(CGFloat)viewHeight;

@end
