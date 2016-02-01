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
    }];
} 


@end
