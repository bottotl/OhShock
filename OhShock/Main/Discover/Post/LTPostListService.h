//
//  LTPostListService.h
//  OhShock
//
//  Created by Lintao.Yu on 1/15/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LTModelPost;
@class LTPostModel;
typedef void (^LTModelPostFindResponse)(NSArray <LTModelPost *> *posts, NSError *error);
typedef void (^LTPostModelFindResponse)(NSArray <LTPostModel *> *posts, NSError *error);

@interface LTPostListService : NSObject
/**
 *  查询 LTModelPost
 *
 *  @param fromIndex 从第几条开始查询（0...N）
 *  @param length    查询几条
 *  @param block     (^LTModelPostFindResponse)(NSArray <LTModelPost *> *posts, NSError *error)
 */
-(void)findModelPost:(NSInteger)fromIndex length:(NSUInteger)length block:(LTModelPostFindResponse)block;
@end
