//
//  LTModelPost.m
//  OhShock
//
//  Created by lintao.yu on 16/1/15.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTModelPost.h"

@implementation LTModelPost
@dynamic pubUser, content, comments, photos, thumbPhotos;
+ (NSString *)parseClassName {
    return @"Post";
}
@end
