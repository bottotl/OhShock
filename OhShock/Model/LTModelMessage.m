//
//  LTModelMessage.m
//  OhShock
//
//  Created by chenlong on 16/1/16.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTModelMessage.h"

@implementation LTModelMessage

@synthesize sendFrom, sendTo, content, isRead, isGroup, info;


+ (NSString *)parseClassName {
    return @"LTModelMessage";
}
@end
