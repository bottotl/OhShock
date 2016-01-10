//
//  LTPostCommitModel.h
//  OhShock
//
//  Created by Lintao.Yu on 1/9/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTPostCommitModel : NSObject

/** 评论 @[<NSAttributedString *>]*/
@property (nonatomic, strong) NSArray *commits;

@end
