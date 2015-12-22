//
//  LTChatModel.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/16.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTChatModel.h"
#import "LTChatService.h"

@interface LTChatModel ()

@end

@implementation LTChatModel

-(instancetype)initWithUser:(AVUser *)user{
    self = [self init];
    if (self) {
        self.service = [[LTChatService alloc]initWithUser:user];
        _incomingUser = user;
        _outgoingUser = [self.service getCurrentUser];
        
        self.messages = [[NSMutableArray alloc]initWithCapacity:15];
        [_service getAvatorImageOfUser:_incomingUser complete:^(UIImage *image, NSError *error) {
            _incomingAvatarImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:image diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        }];
        [_service getAvatorImageOfUser:_outgoingUser complete:^(UIImage *image, NSError *error) {
            _outgoingAvatarImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:image diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        }];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    }
    
    return self;
}

-(NSString *)outgoingID{
    return [_service getCurrentUser].username;
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
