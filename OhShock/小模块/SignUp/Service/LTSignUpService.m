//
//  LTSignUpService.m
//  OhShock
//
//  Created by Lintao.Yu on 12/4/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTSignUpService.h"
#import <AVOSCloud/AVOSCloud.h>
#import "LTModelUserInfo.h"

@implementation LTSignUpService

- (void)signUpWithAccount:(nonnull NSString *)account password:(nonnull NSString *)password email:(nullable NSString *)email phone:(nullable NSString *)phone complete:(nullable LTSignUpResponse)completeBlock{
    AVUser *user = [AVUser new];
    user.username = account;
    user.password = password;
    //user.email = email;
    //[user setObject:phone forKey:@"phone"];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //在注册成功时为用户创建UserInfo表
            LTModelUserInfo *userInfo = [[LTModelUserInfo alloc]init];
            [userInfo setObject:user forKey:@"user"];
            [userInfo saveInBackground];
        }
        if (completeBlock) {
            completeBlock(succeeded,error);
        }
    }];
}

@end
