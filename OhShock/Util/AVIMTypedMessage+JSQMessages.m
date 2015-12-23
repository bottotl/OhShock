//
//  AVIMTypedMessage+JSQMessages.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/23.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "AVIMTypedMessage+JSQMessages.h"
#import "JSQMessage.h"

@implementation AVIMTypedMessage (JSQMessages)
- (JSQMessage *)toJSQMessagesWithSenderId:(NSString *)SenderId andDisplayName:(NSString *)displayName andDate:(NSDate *)date{
    if(!displayName){
        displayName = @"用户名没有设置";
    }
    return [[JSQMessage alloc] initWithSenderId:SenderId
                              senderDisplayName:displayName
                                           date:date
                                           text:self.text];
}

@end
