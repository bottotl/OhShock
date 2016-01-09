//
//  LTPostCommitsView.h
//  OhShock
//
//  Created by Lintao.Yu on 1/9/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTPostCommitModel.h"
/**
 *  评论列表
 */
@interface LTPostCommitsView : UIView

-(void)configWithData:(LTPostCommitModel *)data;

+(CGFloat)heightWithData:(LTPostCommitModel *)data andWidth:(CGFloat)width;

@end
