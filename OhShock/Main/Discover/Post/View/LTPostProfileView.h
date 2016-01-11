//
//  LTPostProfileView.h
//  OhShock
//
//  Created by Lintao.Yu on 16/1/5.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LTPostProfileModel.h"

/**
 *  显示个人信息
 */
@interface LTPostProfileView : UIView
/**
 *  头像展示控件
 */
@property (nonatomic, strong) UIImageView  *avatarView;

/**
 *  数据
 */
@property (nonatomic, strong) LTPostProfileModel *data;

/**
 *  用户小头像 Url
 */
@property (nonatomic, copy) NSString *avatatUrlSmall;


/**
 *  用户名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  头像点击信号
 */
@property (nonatomic,strong) RACSignal *rac_gestureSignal;

/** 获取总高度*/
+(CGFloat)viewHeight;

@end
