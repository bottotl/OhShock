//
//  LTStatusTagView.h
//  LTDynamicCellDemo
//
//  Created by Lintao.Yu on 15/12/11.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYLabel;
@class LTStatusCell;
@class WBStatusLayout;
@interface LTStatusTagView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) YYLabel *label;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, weak) LTStatusCell *cell;
- (void)setWithLayout:(WBStatusLayout *)layout;

@end
