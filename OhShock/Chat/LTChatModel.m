//
//  LTChatModel.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/16.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTChatModel.h"

@implementation LTChatModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
        self.messages = [[NSMutableArray alloc]initWithCapacity:15];
        self.avatars = [[NSMutableDictionary alloc]initWithCapacity:2];
    }
    
    return self;
}
-(NSString *)outgoingID{
    return @"outgoingID";
}
-(NSString *)incomingID{
    return @"incomingID";
}
-(NSString *)outgoingDisplayName{
    return @"outgoingDisplayName";
}
-(NSString *)incomingDisplayName{
    return @"incomingDisplayName";
}
@end
