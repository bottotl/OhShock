//
//  LTStatusCardView.h
//  LTDynamicCellDemo
//
//  Created by Lintao.Yu on 15/12/11.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYKit.h"
#import "WBStatusLayout.h"

@class LTStatusCell;

@interface LTStatusCardView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *badgeImageView;
@property (nonatomic, strong) YYLabel *label;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, weak) LTStatusCell *cell;


- (void)setWithLayout:(WBStatusLayout *)layout isRetweet:(BOOL)isRetweet;
@end
