//
//  LTPostListService.h
//  OhShock
//
//  Created by Lintao.Yu on 1/15/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LTModelPost;
typedef void (^LTPostFindResponse)(NSArray <LTModelPost *> *posts, NSError *error);

@interface LTPostListService : NSObject
/**
 *  查询 Post
 *
 *  @param fromIndex 从第几条开始查询（0...N）
 *  @param length    查询几条
 *  @param block     回调
 */
-(void)findPost:(NSInteger)fromIndex length:(NSUInteger)length block:(LTPostFindResponse)block;

@end
