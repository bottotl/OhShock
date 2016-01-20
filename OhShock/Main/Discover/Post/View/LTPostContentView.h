//
//  LTPostContentView.h
//  OhShock
//
//  Created by Lintao.Yu on 16/1/5.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const LTPostContentLabelPadding = 5;
/**
 *  用户发布的文字内容
 */
@interface LTPostContentView : UIView

@property (nonatomic, copy) NSAttributedString *content;

/**
 *  根据文字内容&宽度获取高度
 *
 *  @param content 富文本
 *  @param width   宽度
 *
 *  @return 高度
 */
+(CGFloat)heightWithContent:(NSAttributedString *)content andPreferedWidth:(CGFloat)width;

@end
