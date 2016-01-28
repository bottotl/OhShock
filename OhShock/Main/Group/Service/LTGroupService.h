//
//  LTGroupService.h
//  OhShock
//
//  Created by chenlong on 16/1/13.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTModelGroup.h"
#import "LTModelMessage.h"

@interface LTGroupService : NSObject


/**
 *  创建群组
 *
 *  @param group          (LTModelGroup *)
 *  @param complectBlock Block
 */
- (void)createGroupWith:(LTModelGroup *)group andCallback:(void(^)(BOOL succeeded, NSError *error))complectBlock;


/**
 *  获取用户群组列表
 *
 *  @param user          (AVUser *)
 *  @param complectBlock Block
 */
- (void)getGroupOfUser:(AVUser *)user andCallback:(void(^)(BOOL succeeded, NSError *error, NSArray *array))complectBlock;


/**
 *  获取群组成员
 *
 *  @param group          (LTModelGroup *)
 *  @param complectBlock Block
 */
- (void)getMembersOfGroup:(LTModelGroup *)group andCallback:(void(^)(BOOL succeeded, NSError *error, NSArray *array))complectBlock;

/**
 *  按关键字搜索群组
 *
 *  @param partName      搜索关键字
 *  @param completeBlock 回调 Block
 */
- (void)findGroupByPartname:(NSString *)partName complete:(void(^)(BOOL succeeded, NSError *error, NSArray *array))completeBlock;


/**
 *  申请加入群组
 *
 *  @param group          (LTModelGroup *)
 *  @param complectBlock Block
 */
- (void)joinGroupWith:(LTModelGroup *)group andCallback:(void(^)(BOOL succeeded, NSError *error))complectBlock;


/**
 *  将用户加入群组（群主通过用户申请）
 *
 *  @param user          (AVUser *)
 *  @param group         (LTModelGroup *)
 *  @param complectBlock Block
 */
- (void)let:(AVUser *)user getInGroup:(LTModelGroup *)group andCallback:(void(^)(BOOL succeeded, NSError *error))complectBlock;

/**
 *  添加消息
 *
 *  @param message       (LTModelMessage *)
 *  @param complectBlock Block
 */
- (void)addMessage:(LTModelMessage *)message andCallback:(void(^)(BOOL succeeded, NSError *error))complectBlock;


///**
// *  添加未读消息到队列（该队列在user表中是一个字段，保存为消息ID数组）
// *
// *  @param message       (LTModelMessage *)
// *  @param complectBlock Block
// */
//- (void)addUnreadMessage:(NSString *)messageID andCallback:(void(^)(BOOL succeeded, NSError *error))complectBlock;


/**
 *  获取未读消息
 *
 *  @param completeBlock 回调 Block
 */
- (void)getUnReadMessagesWithcomplete:(void(^)(BOOL succeeded, NSError *error, NSArray *array))completeBlock;



@end
