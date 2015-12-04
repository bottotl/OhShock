//
//  LTLogInService.h
//  OhShock
//
//  Created by Lintao.Yu on 12/4/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVUser;
typedef void (^LTLogInResponse)(AVUser *user, NSError *error);
/**
 *  @author Lintao Yu, 15-12-04 16:12:44
 *
 *  提供和登陆业务相关的服务
 */
@interface LTLogInService : NSObject
/**
 *  @author Lintao Yu, 15-12-04 16:12:44
 *
 *  通过 [AVUser currentUser] 从本地获取是否已经登陆
 *
 *
 *  @return 登陆的用户（AVUser *）
 */
+ (id)currentUser;

/**
 *  @author Lintao Yu, 15-12-04 17:12:58
 *
 *  登陆
 *
 *  @param account       用户名
 *  @param password      密码
 *  @param completeBlock 登陆状况的 block
 */
- (void)logInWithAccount:(NSString *)account password:(NSString *)password complete:(LTLogInResponse)completeBlock;

@end
