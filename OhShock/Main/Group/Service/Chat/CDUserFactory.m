//
//  CDUserFactory.m
//  OhShock
//
//  Created by chenlong on 16/1/31.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "CDUserFactory.h"
#import "LTModelUser.h"
//#import "CDUserModel.h"
//#import "CDChatManager.h"

@interface CDUser : NSObject <CDUserModel>

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSString *avatarUrl;

@end

@implementation CDUser

@end


@implementation CDUserFactory

#pragma mark - CDUserDelegate

// cache users that will be use in getUserById
- (void)cacheUserByIds:(NSSet *)userIds block:(AVIMBooleanResultBlock)block {
    block(YES, nil); // don't forget it
}

- (id <CDUserModel> )getUserById:(NSString *)userId {
    CDUser *user = [[CDUser alloc] init];
    user.userId = userId;
    user.username = userId;
    user.avatarUrl = @"http://ac-x3o016bx.clouddn.com/86O7RAPx2BtTW5zgZTPGNwH9RZD5vNDtPm1YbIcu";
    return user;
}

@end