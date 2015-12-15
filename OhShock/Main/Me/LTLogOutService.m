//
//  LTLogOutService.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/15.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTLogOutService.h"
#import <AVOSCloud/AVOSCloud.h>
#import "LogInViewController.h"


@implementation LTLogOutService
+(void)logOut{
    [AVUser logOut];
    LogInViewController *loginViewController = [LogInViewController new];
    [[UIApplication sharedApplication].delegate.window.rootViewController removeFromParentViewController];
     [[UIApplication sharedApplication].delegate.window setRootViewController:loginViewController];
    
}
@end
