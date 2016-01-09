//
//  LTPostModel.h
//  OhShock
//
//  Created by Lintao.Yu on 16/1/3.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTPostProfileModel.h"
#import "LTPostContentModel.h"
#import "LTPostImageModel.h"
#import "LTPostLikedModel.h"

@interface LTPostModel : NSObject

/** 个人资料*/
@property (nonatomic, strong) LTPostProfileModel *profileData;

/** 内容*/
@property (nonatomic, strong) LTPostContentModel *contentData;

/** 图片的 Url @[<LTPostImageModel *>]*/
@property (nonatomic, strong) NSArray *pic;

/** 点赞列表数据模型*/
@property (nonatomic, strong) LTPostLikedModel *likedData;

@end
