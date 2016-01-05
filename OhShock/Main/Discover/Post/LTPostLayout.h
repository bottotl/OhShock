//
//  LTPostLayout.h
//  OhShock
//
//  Created by Lintao.Yu on 16/1/3.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYKit.h"
#import "LTPostLayoutProtocol.h"
@interface LTPostLayout : NSObject
//- (instancetype)initWithStatus:(WBStatus *)status style:(WBLayoutStyle)style;
- (void)layout; ///< 计算布局
- (void)updateDate; ///< 更新时间字符串

// 总高度
@property (nonatomic, assign) CGFloat height;

@end
