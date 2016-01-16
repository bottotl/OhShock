//
//  LTModelPost.h
//  OhShock
//
//  Created by lintao.yu on 16/1/15.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@class LTModelUser;
@interface LTModelPost : AVObject <AVSubclassing>

/** 发布者 */
@property (nonatomic, strong) LTModelUser *pubUser;

/** post 内容 */
@property (nonatomic, copy) NSString *content;

/** 评论 NSArray <LTModelPostComment *>* */
@property (nonatomic, strong) NSArray *comments;

/** 需要上传的图片 _File */
@property (nonatomic, strong) NSArray *photos;

@end
