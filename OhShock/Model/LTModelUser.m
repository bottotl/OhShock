//
//  LTUser.m
//  OhShock
//
//  Created by Lintao.Yu on 1/10/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import "LTModelUser.h"

@implementation LTModelUser

@dynamic avatar,username;
+ (NSString *)parseClassName {
    return @"_User";
}
@end
