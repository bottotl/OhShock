//
//  LTChatService.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/16.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTChatService.h"

@interface LTChatService()
/// 接收方
@property (nonatomic, strong) AVUser *toUser;
@end

@implementation LTChatService
-(instancetype)initWithUser:(AVUser *)user{
    self = [super init];
    if (self) {
        _toUser = user;
    }
    return self;
}
#pragma mark - 获取当前用户
- (AVUser *)getCurrentUser{
    return [AVUser currentUser];
}
#pragma mark -  获取用户头像
- (void)getAvatorImageOfUser:(AVUser *)user complete:(void(^)(UIImage *image, NSError *error))complectBlock{
    AVFile *avatar = [user objectForKey:@"avatar"];
    if (avatar) {
        [avatar getDataInBackgroundWithBlock: ^(NSData *data, NSError *error) {
            if (error == nil) {
                complectBlock([UIImage imageWithData:data],error);
            }else{
                complectBlock([UIImage imageNamed:@"zxyxwanzi_mobile"],error);;
            }
        }];
        
    }
    
}

- (void)getAvatorUrlString:(AVUser *)user complete:(void(^)(NSString *urlString, NSError *error))completeBlock{
    AVFile *avatorFile = [user objectForKey:@"avatar"];
    if (completeBlock) {
        if (avatorFile) {
            completeBlock(avatorFile.url,nil);
        }else{
            NSLog(@"getAvatorUrlString error");
        }
        
    }
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
    
}
#pragma mark 接收到新的富媒体消息
/*!
 接收到新的富媒体消息。
 @param conversation － 所属对话
 @param message - 具体的消息
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    
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
