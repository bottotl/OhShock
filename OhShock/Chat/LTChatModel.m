//
//  LTChatModel.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/16.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTChatModel.h"
#import "LTChatService.h"
#import "CDChatManager.h"
#import "AVIMTypedMessage+JSQMessages.h"
#import "CDEmotionUtils.h"
#import "ReactiveCocoa/ReactiveCocoa.h"

@interface LTChatModel ()

@end

@implementation LTChatModel
#pragma mark -  初始化
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
        
        [self initConversation];
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
-(void)initConversation{
    __weak __typeof(self) weakSelf = self;
    [[CDChatManager manager] openWithClientId:[AVUser currentUser].objectId callback: ^(BOOL succeeded, NSError *error) {
        if (!error) {
            if (succeeded) {
                [[CDChatManager manager] fetchConvWithOtherId:self.incomingUser.objectId callback: ^(AVIMConversation *conversation, NSError *error) {
                    if (error) {
                        NSLog(@"fetchConvWithOtherId %@",error);
                    }else{
                        weakSelf.conv = conversation;
                        NSLog(@"fetchConvWithOtherId 成功");
                        //查询成功后加载会话
                        [weakSelf loadMessagesWhenInit];
                    }
                    
                }];
            }
        }else{
            NSLog(@"initConversation error :%@",error);
        }
    }];
    
}

- (void)loadMessagesWhenInit {
    __weak __typeof(self) weakSelf = self;
    [weakSelf.conv queryMessagesWithLimit:kPageSize callback:^(NSArray *objects, NSError *error) {
        if(error){
            NSLog(@"查询消息失败：%@",error);
        }else{
            NSLog(@"查询消息成功： objects :%@",objects);
            for (AVIMTypedMessage *message in objects) {
                [weakSelf.messages addObject:[message toJSQMessagesWithSenderId:message.clientId andDisplayName:[message.attributes valueForKey:@"username"] andDate:[NSDate dateWithTimeIntervalSince1970:message.sendTimestamp]]];
            }
            self.messagesCount = self.messages.count;
        }
    }];
}
#pragma mark - 发送聊天内容
-(void)sendMessage:(NSString *)text{
    AVIMTextMessage *msg = [AVIMTextMessage messageWithText:[CDEmotionUtils plainStringFromEmojiString:text] attributes:nil];
    [msg.attributes setValue:self.outgoingDisplayName forKey:@"username"];
    
    [self sendMsg:msg originFilePath:nil];
}
- (void)sendMsg:(AVIMTypedMessage *)msg originFilePath:(NSString *)path {
    [[CDChatManager manager] sendMessage:msg conversation:self.conv callback:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"发送消息失败%@",error);
        } else {
            if(succeeded){
                NSLog(@"发送消息成功");
            }else{
                NSLog(@"发送消息失败");
            }
            if (path) {
                if (msg.mediaType == kAVIMMessageMediaTypeAudio) {
                    // 移动文件，好根据 messageId 找到本地文件缓存
                    NSString *newPath = [[CDChatManager manager] getPathByObjectId:msg.messageId];
                    NSError *error1;
                    [[NSFileManager defaultManager] moveItemAtPath:path toPath:newPath error:&error1];
                    DLog(@"%@", newPath);
                }
            }
        }
    }];
}

#pragma mark - 手动刷新
- (void)updateMessage{
    [self loadMessagesWhenInit];
}

#pragma mark - property
-(NSString *)outgoingID{
    return [_service getCurrentUser].objectId;
}
-(NSString *)incomingID{
    return self.incomingUser.objectId;
}
-(NSString *)outgoingDisplayName{
    return self.outgoingUser.username;
}
-(NSString *)incomingDisplayName{
    return self.incomingUser.username;
}
@end
