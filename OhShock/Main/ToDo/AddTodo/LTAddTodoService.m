//
//  LTAddTodoService.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/27.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTAddTodoService.h"
#import "AVOSCloud/AVOSCloud.h"

@implementation LTAddTodoService
+(void)saveTodoToServerWithContent:(NSString *)content type:(NSString *)type startTime:(NSDate *)startTime endTime:(NSDate *)endTime friends:(NSArray *)friends{
    AVObject *todo = [AVObject objectWithClassName:@"Todo"];
    [todo setObject:content forKey:@"content"];
    [todo setObject:type forKey:@"type"];
    [todo setObject:startTime forKey:@"startTime"];
    [todo setObject:endTime forKey:@"endTime"];
    [todo setObject:friends forKey:@"friends"];
    [todo save];
}
@end
