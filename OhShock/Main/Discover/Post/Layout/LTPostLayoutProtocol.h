//
//  LTPostLayoutProtocol.h
//  OhShock
//
//  Created by Lintao.Yu on 16/1/5.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol LTPostLayoutProtocol <NSObject>
@required
- (void)layout; ///< 计算布局
- (CGFloat)layoutHeight;///< 总高度
@end
