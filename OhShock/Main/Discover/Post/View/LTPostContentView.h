//
//  LTPostContentView.h
//  OhShock
//
//  Created by Lintao.Yu on 16/1/5.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const LTPostContentLabelPadding = 5;

@interface LTPostContentView : UIView

@property (nonatomic, copy) NSAttributedString *content;

+(CGFloat)viewHeightWithContent:(NSAttributedString *)content width:(CGFloat)width;

@end
