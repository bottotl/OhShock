//
//  LTChatModel.h
//  OhShock
//
//  Created by Lintao.Yu on 15/12/16.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSQMessages.h"
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "LTModelUser.h"

@class LTChatService;
@class AVUser;
@class AVIMConversation;
@class RACSignal;

///初始化页面需要加载的聊天数据的数量
static NSInteger const kPageSize = 15;
/**
 *  @author Lintao Yu, 15-12-16 13:12:24
 *
 *  两个用户之间对话的页面数据模型
 *  重要！请用 ReactiveCocoa 绑定 messagesCount ,每次这个参数更新了表示刷新了数据
 *  不然聊天页面不会刷新
 */
@interface LTChatModel : NSObject<AVIMClientDelegate>
/**
 *  重要属性
 */

/// 她
@property (nonatomic, strong) LTModelUser *incomingUser;
/// 我
@property (nonatomic, strong) LTModelUser *outgoingUser;
/// 会话
@property (strong, nonatomic) AVIMConversation *conv;

/**
 *  聊天需要的网络服务 service
 */
@property (nonatomic, strong) LTChatService *service;

/**
 *  聊天页面
 */
/// 一个 JSQMessage 类型的数组
@property (nonatomic, strong) NSMutableArray *messages;
/**
 *  消息的数量
 *  重要！请 用 ReactiveCocoa 绑定这个参数，每次这个参数更新了表示刷新了数据
 */
@property (nonatomic, assign) NSUInteger messagesCount;
/// 对方的头像
@property (nonatomic, strong) JSQMessagesAvatarImage *incomingAvatarImage;
/// 我的头像
@property (nonatomic, strong) JSQMessagesAvatarImage *outgoingAvatarImage;
/// 接收方的气泡背景
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
/// 发送方的气泡背景
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;
///聊天成员(保存的是objectId数组
@property (strong, nonatomic) NSArray *members;
/// 我的 ID
-(NSString *)outgoingID;
/// 对方的 ID
-(NSString *)incomingID;
/// 我的用户名
-(NSString *)outgoingDisplayName;
/// 对方的用户名
-(NSString *)incomingDisplayName;

/**
 *  初始化方法（必须调用这个初始化）
 *
 *  @param user (AVUser *)
 *
 *  @return self
 */
-(instancetype)initWithMembers:(NSArray *)members;

/**
 *  初始化方法（必须调用这个初始化）
 *
 *  @param user (AVUser *)
 *
 *  @return self
 */
-(instancetype)initWithUser:(AVUser *)user;
/**
 *  发送消息
 *
 *  @param text 发送的富文本
 */
- (void)sendMessage:(NSString *)text;
/**
 *  手动刷新聊天数据
 */
- (void)updateMessage;
@end
