//
//  LTPostProfileModel.h
//  OhShock
//
//  Created by Lintao.Yu on 1/8/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTPostProfileModel : NSObject
/** 用户名 */
@property (nonatomic, copy) NSString *name;
/** 小头像 Url */
@property (nonatomic, copy) NSString *avatarUrlSmall;
/** 大头像 Url */
@property (nonatomic, copy) NSString *avatarUrlBig;

@end
