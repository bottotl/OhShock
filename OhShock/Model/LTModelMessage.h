//
//  LTModelMessage.h
//  OhShock
//
//  Created by chenlong on 16/1/16.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "LTModelUser.h"
@interface LTModelMessage : AVObject<AVSubclassing>


@property (nonatomic, strong) LTModelUser *sendFrom;//谁发出的，像系统提示等默认为Service
@property (nonatomic, strong) LTModelUser *sendTo;//推送给谁
@property (nonatomic, copy) NSString *content;//消息内容
@property (nonatomic, assign) BOOL isRead;//是否已读，默认为NO
@property (nonatomic, assign) BOOL isGroup;//是否是群聊消息，默认为NO
@property (nonatomic, copy) NSDictionary *info;//附带的信息，默认为空

@end
