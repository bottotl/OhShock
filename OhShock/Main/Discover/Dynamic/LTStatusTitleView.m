//
//  LTStatusTitleView.m
//  LTDynamicCellDemo
//
//  Created by Lintao.Yu on 15/12/11.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTStatusTitleView.h"

@implementation LTStatusTitleView
- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = kWBCellTitleHeight;
    }
    self = [super initWithFrame:frame];
    _titleLabel = [YYLabel new];
    _titleLabel.size = CGSizeMake(kScreenWidth - 100, self.height);
    _titleLabel.left = kWBCellPadding;
    _titleLabel.displaysAsynchronously = YES;
    _titleLabel.ignoreCommonProperties = YES;
    _titleLabel.fadeOnHighlight = NO;
    _titleLabel.fadeOnAsynchronouslyDisplay = NO;
    [self addSubview:_titleLabel];
    
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width, CGFloatFromPixel(1));
    line.bottom = self.height;
    line.backgroundColor = kWBCellLineColor.CGColor;
    [self.layer addSublayer:line];
    self.exclusiveTouch = YES;
    return self;
    
}
@end
