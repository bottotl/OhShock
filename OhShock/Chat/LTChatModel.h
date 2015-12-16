//
//  LTChatModel.h
//  OhShock
//
//  Created by Lintao.Yu on 15/12/16.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSQMessages.h"
/**
 *  @author Lintao Yu, 15-12-16 13:12:24
 *
 *  两个用户之间对话的页面数据模型
 */
@interface LTChatModel : NSObject
/// 一个 JSQMessage 类型的数组
@property (strong, nonatomic) NSMutableArray *messages;
/// 一个实现了 <JSQMessageAvatarImageDataSource> 协议的类型的字典
/// 以用户 ID 作为索引
@property (strong, nonatomic) NSMutableDictionary *avatars;
/// 接收方的气泡背景
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
/// 发送方的气泡背景
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;
-(NSString *)outgoingID;
-(NSString *)incomingID;
-(NSString *)outgoingDisplayName;
-(NSString *)incomingDisplayName;
@end
