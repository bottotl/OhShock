//
//  LTModelPostComment.h
//  OhShock
//
//  Created by lintao.yu on 16/1/15.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>


@class LTModelUser;
/**
 *  一条评论
 */
@interface LTModelPostComment : AVObject

/** 回应内容 */
@property (nonatomic, copy) NSString * content;
/** 被回应的用户 */
@property (nonatomic, strong) LTModelUser * toUser;
/** 发表回应用户 */
@property (nonatomic, strong) LTModelUser * fromUser;

@end

