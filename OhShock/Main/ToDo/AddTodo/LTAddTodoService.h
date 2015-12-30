//
//  LTAddTodoService.h
//  OhShock
//
//  Created by Lintao.Yu on 15/12/27.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTAddTodoService : NSObject
+(void)saveTodoToServerWithContent:(NSString *)content type:(NSString *)type startTime:(NSDate *)startTime endTime:(NSDate *)endTime friends:(NSArray *)friends;
@end
