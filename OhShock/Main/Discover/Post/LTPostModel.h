//
//  LTPostModel.h
//  OhShock
//
//  Created by lintao.yu on 16/1/22.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVFile;
@interface LTPostModel : NSObject

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSString *avatarUrlString;

@property (nonatomic, strong) NSAttributedString *content;

@property (nonatomic, strong) NSArray < AVFile *> *picFiles;

@property (nonatomic, strong) NSMutableArray < AVFile *> *picThumbFiles;

//@property (nonatomic, strong) NSDictionary *photoThumbUrls;

@property (nonatomic, strong) NSAttributedString *likedUsersAttributedString;

@property (nonatomic, strong) NSArray < NSAttributedString *> *comments;

@property (nonatomic, assign) BOOL liked;///< 是否点赞

@end
