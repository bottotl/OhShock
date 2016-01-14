//
//  LTLogInService.m
//  OhShock
//
//  Created by Lintao.Yu on 12/4/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTLogInService.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation LTLogInService

+ (id)currentUser{
    return [AVUser currentUser];
}
- (void)logInWithAccount:(NSString *)account password:(NSString *)password complete:(LTLogInResponse)completeBlock{
    [AVUser logInWithUsernameInBackground:account password:password block:^(AVUser *user, NSError *error) {
        completeBlock(user,error);
    }];
}


@end
