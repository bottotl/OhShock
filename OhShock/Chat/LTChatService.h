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
#import <AVOSCloud/AVOSCloud.h>

@class AVUser;
@class LTChatModel;

@interface LTChatService : NSObject <AVIMClientDelegate>
-(instancetype)initWithUser:(AVUser *)user;
@property (nonatomic, weak) LTChatModel *dataSource;
/// 获取当前用户
- (AVUser *)getCurrentUser;
/**
 *  获取用户头像（UIImage） 如果只是需要 URL
 *
 *  请使用：
 *
 *  - (void)getAvatorUrlString:(AVUser *)user complete:(void(^)(NSString *urlString, NSError *error))completeBlock
 *
 *  @param user          (AVUser *)
 *  @param complectBlock Block
 */
- (void)getAvatorImageOfUser:(AVUser *)user complete:(void(^)(UIImage *image, NSError *error))complectBlock;
/**
 *  获取用户头像的 URL
 *
 *  @param user          (AVUser *)
 *  @param completeBlock Block
 */
- (void)getAvatorUrlString:(AVUser *)user complete:(void(^)(NSString *urlString, NSError *error))completeBlock;

@end
