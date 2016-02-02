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
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LTChatModel ()

@end

@implementation LTChatModel
#pragma mark -  初始化
-(instancetype)initWithUser:(LTModelUser *)user{
    self = [self init];
    if (self) {
        self.service = [[LTChatService alloc]initWithUser:user];
        _incomingUser = user;
        _outgoingUser = [LTModelUser currentUser];
        
        self.messages = [[NSMutableArray alloc]initWithCapacity:15];
        /// 获取头像
        [_service getAvatorImageOfUser:_incomingUser complete:^(UIImage *image, NSError *error) {
            if (!error) {
                _incomingAvatarImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:image diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
            }else{
                NSLog(@"getAvatorImageOfUser 错误 ：%@",error);
            }
            
        }];
        [_service getAvatorImageOfUser:_outgoingUser complete:^(UIImage *image, NSError *error) {
            if (!error) {
                _outgoingAvatarImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:image diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
            }else{
                NSLog(@"getAvatorImageOfUser 错误 ：%@",error);
            }
            
        }];

        [self initSingleConversation];
#pragma mark 设置代理
        [AVIMClient defaultClient].delegate = self;
    }
    return self;
}

-(instancetype) initWithMembers:(NSArray *)members{
    self = [self init];
    if (self) {
        self.service = [[LTChatService alloc]init];
        _outgoingUser = [LTModelUser currentUser];
        _members = members;
        
        self.messages = [NSMutableArray array];
        
        //获取自己的头像
        [_service getAvatorImageOfUser:_outgoingUser complete:^(UIImage *image, NSError *error) {
            if (!error) {
                _outgoingAvatarImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:image diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
            }else{
                NSLog(@"getAvatorImageOfUser 错误 ：%@",error);
            }
            
        }];
    }
    [self initGroupConversation];
#pragma mark 设置代理
    [AVIMClient defaultClient].delegate = self;

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
#pragma mark 初始化会话
/**
 *  获取会话
 */
-(void)initSingleConversation{
    __weak __typeof(self) weakSelf = self;
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

- (void)initGroupConversation{
    __weak __typeof(self) weakSelf = self;
    [[CDChatManager manager] fetchConvWithMembers:_members callback:^(AVIMConversation *conversation, NSError *error) {
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

- (void)loadMessagesWhenInit {
    __weak __typeof(self) weakSelf = self;
    [weakSelf.conv queryMessagesWithLimit:kPageSize callback:^(NSArray *objects, NSError *error) {
        if(error){
            NSLog(@"查询消息失败：%@",error);
        }else{
            NSLog(@"查询消息成功： objects :%@",objects);
            for (AVIMTypedMessage *message in objects) {
                NSLog(@"%@", message.attributes);
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
    NSLog(@"%@", msg.attributes);
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

#pragma mark - AVIMClientDelegate

#pragma mark 聊天状态被暂停，常见于网络断开时触发

/**
 *  当前聊天状态被暂停，常见于网络断开时触发。
 *  注意：该回调会覆盖 imClientPaused: 方法。
 *  @param imClient 相应的 imClient
 *  @param error    具体错误信息
 */
- (void)imClientPaused:(AVIMClient *)imClient error:(NSError *)error{
    
}

#pragma mark 当前聊天状态开始恢复，常见于网络断开后开始重新连接。
/**
 *  当前聊天状态开始恢复，常见于网络断开后开始重新连接。
 *  @param imClient 相应的 imClient
 */
- (void)imClientResuming:(AVIMClient *)imClient{
    
}

#pragma mark 当前聊天状态已经恢复，常见于网络断开后开始重新连接。
/**
 *  当前聊天状态已经恢复，常见于网络断开后重新连接上。
 *  @param imClient 相应的 imClient
 */
- (void)imClientResumed:(AVIMClient *)imClient{
    
}

#pragma mark 接收到新的普通消息
/*!
 接收到新的普通消息。
 @param conversation － 所属对话
 @param message - 具体的消息
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message{
    NSLog(@"接收到新的普通消息");
}
#pragma mark 接收到新的富媒体消息
/*!
 接收到新的富媒体消息。
 @param conversation － 所属对话
 @param message - 具体的消息
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    [self.messages addObject:[message toJSQMessagesWithSenderId:message.clientId andDisplayName:[message.attributes valueForKey:@"username"] andDate:[NSDate dateWithTimeIntervalSince1970:message.sendTimestamp]]];
    NSLog(@"message %@",message.text);
    self.messagesCount = self.messages.count;
    
}
#pragma mark 消息已投递给对方
/*!
 消息已投递给对方。
 @param conversation － 所属对话
 @param message - 具体的消息
 */
- (void)conversation:(AVIMConversation *)conversation messageDelivered:(AVIMMessage *)message{
    
}


#pragma mark 对话中有新成员加入时所有成员都会收到这一通知
/*!
 对话中有新成员加入时所有成员都会收到这一通知。
 @param conversation － 所属对话
 @param clientIds - 加入的新成员列表
 @param clientId - 邀请者的 id
 */
- (void)conversation:(AVIMConversation *)conversation membersAdded:(NSArray *)clientIds byClientId:(NSString *)clientId{
    
}

#pragma mark 对话中有成员离开时所有剩余成员都会收到这一通知。
/*!
 对话中有成员离开时所有剩余成员都会收到这一通知。
 @param conversation － 所属对话
 @param clientIds - 离开的成员列表
 @param clientId - 操作者的 id
 */
- (void)conversation:(AVIMConversation *)conversation membersRemoved:(NSArray *)clientIds byClientId:(NSString *)clientId{
    
}
#pragma mark 当前用户被邀请加入对话的通知
/*!
 当前用户被邀请加入对话的通知。
 @param conversation － 所属对话
 @param clientId - 邀请者的 id
 */
- (void)conversation:(AVIMConversation *)conversation invitedByClientId:(NSString *)clientId{
    
}
#pragma mark 当前用户被踢出对话的通知
/*!
 当前用户被踢出对话的通知。
 @param conversation － 所属对话
 @param clientId - 操作者的 id
 */
- (void)conversation:(AVIMConversation *)conversation kickedByClientId:(NSString *)clientId{
    
}
#pragma mark 收到未读通知
/*!
 收到未读通知。在该终端上线的时候，服务器会将对话的未读数发送过来。未读数可通过 -[AVIMConversation markAsReadInBackground] 清零，服务端不会自动清零。
 @param conversation 所属会话。
 @param unread 未读消息数量。
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveUnread:(NSInteger)unread{
    
}
#pragma mark 客户端下线通知
/*!
 客户端下线通知。
 @param client 已下线的 client。
 @param error 错误信息。
 */
- (void)client:(AVIMClient *)client didOfflineWithError:(NSError *)error{
    
}


@end
