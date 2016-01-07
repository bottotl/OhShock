//
//  LTPostViewBaseView.h
//  OhShock
//
//  Created by Lintao.Yu on 16/1/5.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 继承这个类就必须重写 +[LTPostViewBaseView viewHeight]
@interface LTPostViewBaseView : UIView
+(CGFloat)viewHeight;
@end
