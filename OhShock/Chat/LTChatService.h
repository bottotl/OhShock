//
//  LTChatService.h
//  OhShock
//
//  Created by Lintao.Yu on 15/12/16.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

@class AVUser;
@class LTChatModel;

@interface LTChatService : NSObject <AVIMClientDelegate>

@property (nonatomic, weak) LTChatModel *dataSource;
/// 获取当前用户
- (AVUser *)getCurrentUser;
/// 获取用户头像
- (UIImage *)getAvatarImageOfUser:(AVUser *)user;

@end
