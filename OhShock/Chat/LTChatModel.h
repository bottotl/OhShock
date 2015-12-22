//
//  LTChatModel.h
//  OhShock
//
//  Created by Lintao.Yu on 15/12/16.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSQMessages.h"
@class LTChatService;
@class AVUser;
/**
 *  @author Lintao Yu, 15-12-16 13:12:24
 *
 *  两个用户之间对话的页面数据模型
 */
@interface LTChatModel : NSObject
/// 她
@property (nonatomic, strong) AVUser *incomingUser;
/// 我
@property (nonatomic, strong) AVUser *outgoingUser;
/// 聊天需要的网络服务 service
@property (nonatomic, strong) LTChatService *service;
/// 一个 JSQMessage 类型的数组
@property (strong, nonatomic) NSMutableArray *messages;
/// 对方的头像
@property (nonatomic, strong) JSQMessagesAvatarImage *incomingAvatarImage;
/// 我的头像
@property (nonatomic, strong) JSQMessagesAvatarImage *outgoingAvatarImage;
///// 一个实现了 <JSQMessageAvatarImageDataSource> 协议的类型的字典
///// 以用户 ID 作为索引
//@property (strong, nonatomic) NSMutableDictionary *avatars;
/// 接收方的气泡背景
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
/// 发送方的气泡背景
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;
/// 我的 ID
-(NSString *)outgoingID;
/// 对方的 ID
-(NSString *)incomingID;
/// 我的用户名
-(NSString *)outgoingDisplayName;
/// 对方的用户名
-(NSString *)incomingDisplayName;

-(instancetype)initWithUser:(AVUser *)user;
@end
