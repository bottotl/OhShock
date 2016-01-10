//
//  LTPostCommentModel.h
//  OhShock
//
//  Created by Lintao.Yu on 1/10/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LTModels.h"


/**
 *  提供给 LTPostCommentView 用的 评论模型
 */
@interface LTPostCommentModel : NSObject

@property (nonatomic, strong) NSAttributedString  *text;///< 展示的评论文本
@property (nonatomic, assign) NSRange              fromUserRange;
@property (nonatomic, assign) NSRange              toUserRange;
@property (nonatomic, strong) LTModelPostComment  *comment;


- (instancetype)initWithComment:(LTModelPostComment *)comment;

@end
