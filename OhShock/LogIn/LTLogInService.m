//
//  LTLogInService.m
//  OhShock
//
//  Created by Lintao.Yu on 12/4/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTLogInService.h"

@implementation LTLogInService

- (void)logInWithAccount:(NSString *)account password:(NSString *)password complete:(LTLogInResponse)completeBlock{
    
    // for test
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        BOOL success = [account isEqualToString:@"1"] && [password isEqualToString:@"1"];
        NSLog(@"登陆 ：%@",@(success));
        completeBlock(success);
    });
}

@end
