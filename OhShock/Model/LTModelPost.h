//
//  LTModelPost.h
//  OhShock
//
//  Created by lintao.yu on 16/1/15.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@class LTModelUser;
/**
 *  图文动态
 */
@interface LTModelPost : AVObject <AVSubclassing>

/** 发布者 */
@property (nonatomic, strong) LTModelUser *pubUser;

/** 点赞的用户 NSArray < LTModelUser * >*  */
@property (nonatomic, strong) NSArray *likedUser;

/** post 内容 */
@property (nonatomic, copy) NSData *content;

/** 评论 NSArray <LTModelPostComment *>* */
@property (nonatomic, strong) NSArray *comments;

/** 图片 _File */
@property (nonatomic, strong) NSArray *photos;

@end
