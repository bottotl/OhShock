//
//  LTStatusTitleView.h
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
 *  @author Lintao Yu, 15-12-11 17:12:55
 *
 *  状态标题栏
 */
@interface LTStatusTitleView : UIView
@property (nonatomic, strong) YYLabel *titleLabel;
@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, weak) LTStatusCell *cell;
@end
