//
//  LTPostModel.h
//  OhShock
//
//  Created by lintao.yu on 16/1/22.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTPostModel : NSObject

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSString *avatarUrlString;

@property (nonatomic, strong) NSAttributedString *content;

@property (nonatomic, strong) NSArray < NSString *> *picUrls;

@property (nonatomic, strong) NSDictionary *photoThumbUrls;

@property (nonatomic, strong) NSAttributedString *likedUsersAttributedString;

@property (nonatomic, strong) NSArray < NSAttributedString *> *comments;

@end
