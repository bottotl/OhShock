//
//  AVIMTypedMessage+JSQMessages.h
//  OhShock
//
//  Created by Lintao.Yu on 15/12/23.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import <AVOSCloudIM/AVOSCloudIM.h>
@class JSQMessage;
@interface AVIMTypedMessage (JSQMessages)
- (JSQMessage *)toJSQMessagesWithSenderId:(NSString *)SenderId andDisplayName:(NSString *)displayName andDate:(NSDate *)date;

@end
