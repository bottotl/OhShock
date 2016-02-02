//
//  LTLogInService.m
//  OhShock
//
//  Created by Lintao.Yu on 12/4/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTLogInService.h"
#import "LTModelUser.h"

@implementation LTLogInService

+ (id)currentUser{
    return [AVUser currentUser];
}
- (void)logInWithAccount:(NSString *)account password:(NSString *)password complete:(LTLogInResponse)completeBlock{
    [LTModelUser logInWithUsernameInBackground:account password:password block:^(AVUser *user, NSError *error) {
        LTModelUser *me = [LTModelUser currentUser];
        completeBlock(me,error);
        if (!error) {
            //chanels 是一个数组，是用来对用户集推送，所以我自己加了个Token字段来唯一标识用户
            //登录成功后为设备设置推送识别token,在登出时抹掉token
            AVInstallation *installation = [AVInstallation currentInstallation];
            [installation setObject:[[AVUser currentUser]objectForKey:@"objectId"] forKey:@"Token"];
            [installation saveInBackground];
        }
    }];
}

  
@end
