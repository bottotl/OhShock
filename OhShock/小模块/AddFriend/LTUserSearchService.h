//
//  LTUserSearchService.h
//  OhShock
//
//  Created by Lintao.Yu on 15/12/15.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  @author Lintao Yu, 15-12-20 17:12:43
 *
 *  关注关系
 *
 *  I_FOLLOWED_HIM  我关注了他
    HE_FOLLOWED_ME  他关注了我
    NO_RELATIONSHIP 互相没有关注
    BOTH_FOLLOWED   互相关注
 *
 */
typedef NS_ENUM(NSUInteger, LTFollowRelationShipType) {
    /**
     *  @author Lintao Yu, 15-12-20 17:12:43
     *
     *  我关注了他
     */
    I_FOLLOWED_HIM = 0,
    /**
     *  @author Lintao Yu, 15-12-20 17:12:43
     *
     *  他关注了我
     */
    HE_FOLLOWED_ME,
    /**
     *  @author Lintao Yu, 15-12-20 17:12:43
     *
     *  互相没有关注
     */
    NO_RELATIONSHIP,
    /**
     *  @author Lintao Yu, 15-12-20 17:12:43
     *  
     *  互相关注
     */
    BOTH_FOLLOWED
};

@class AVUser;
@class UIImage;
/**
 *  查找用户的 Block
 *
 *  @param users 用户（AVUser *）
 *  @param error 错误
 */
typedef void (^LTFindUsersResponse)(NSArray *users, NSError *error);
/**
 *  查询用户关系的 Block
 *
 *  @param type  用户关系
 *  @param error 错误
 */
typedef void (^LTFindFollowTypeResponse)(LTFollowRelationShipType type, NSError *error);

@interface LTUserSearchService : NSObject
/**
 *  关注用户
 *
 *  @param user          (AVUser *)
 *  @param complectBlock Block
 */
- (void)followUserWith:(AVUser *)user andCallback:(void(^)(BOOL succeeded, NSError *error))complectBlock;
/**
 *  取消关注用户
 *
 *  @param user          (AVUser *)
 *  @param complectBlock Block
 */
- (void)unfollowUserWith:(AVUser *)user andCallback:(void(^)(BOOL succeeded, NSError *error))complectBlock;
/**
 *  改变关注类型
 *  原来如果是关注的改为不关注，如果是不关注的，改为关注
 *
 *  @param user          (AVUser *)
 *  @param complectBlock Block
 */
- (void)changeFollowType:(AVUser *)user andCallback:(void(^)(BOOL succeeded, NSError *error))complectBlock;
/**
 *  按照用户名查找用户
 *
 *  @param partName      用户名
 *  @param completeBlock 回调 Block
 */
- (void)findUsersByPartname:(NSString *)partName complete:(LTFindUsersResponse)completeBlock;
/**
 *  获取关注关系
 *
 *  @param userId        用户 ID
 *  @param completeBlock Block
 */
- (void)getFollowRelationShipWithMe:(NSString *)userId complete:(LTFindFollowTypeResponse)completeBlock;
/**
 *  获取用户粉丝数量
 *
 *  @param user          (AVUser *)
 *  @param completeBlock  Block
 */
- (void)getFollowerNum:(AVUser *)user complete:(void(^)(NSUInteger num, NSError *error))completeBlock;
/**
 *  获取用户关注数量
 *
 *  @param user          (AVUser *)
 *  @param completeBlock Block
 */
- (void)getFolloweeNum:(AVUser *)user complete:(void(^)(NSUInteger num, NSError *error))completeBlock;
/**
 *  获取用户头像（UIImage） 如果只是需要 URL
 *  请使用：
 *  - (void)getAvatorUrlString:(AVUser *)user complete:(void(^)(NSString *urlString, NSError *error))completeBlock
 *
 *  @param user          (AVUser *)
 *  @param complectBlock Block
 */
- (void)getAvatorImageOfUser:(AVUser *)user complete:(void(^)(UIImage *image, NSError *error))complectBlock;
/**
 *  获取用户头像的 URL
 *
 *  @param user          (AVUser *)
 *  @param completeBlock Block
 */
- (void)getAvatorUrlString:(AVUser *)user complete:(void(^)(NSString *urlString, NSError *error))completeBlock;
@end
