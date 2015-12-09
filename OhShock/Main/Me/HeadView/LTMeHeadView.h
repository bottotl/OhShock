//
//  LTMeHeadView.h
//  OhShock
//
//  Created by Lintao.Yu on 12/8/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat LTMeHeadViewHeight = 180;
/**
 *  @author Lintao Yu, 15-12-08 14:12:51
 *
 *  “我”页面的头部
 *  这个控件和 UIScrollView+APParallaxHeader 搭配使用时会不断修改自身的高度（进行伸缩变换）
    所以在布局的时候需要相对于这个控件的底部进行布局
 */
@interface LTMeHeadView : UIImageView
@property (nonatomic, copy) NSString *avatorUrlString;
@end
