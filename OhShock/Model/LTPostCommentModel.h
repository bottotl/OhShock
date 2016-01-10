//
//  LTPostCommentModel.h
//  OhShock
//
//  Created by Lintao.Yu on 1/10/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LTModels.h"

@interface LTModelPostComment : NSObject

/** 回应内容*/
@property (nonatomic, copy) NSString * content;
/** 回应id*/
@property (nonatomic, assign) NSInteger noteId;
/** 被回应的用户*/
@property (nonatomic, strong) LTUser * toUser;
/** 发表回应用户*/
@property (nonatomic, strong) LTUser * fromUser;

@end


@interface LTPostCommentModel : NSObject

@property (nonatomic, strong) NSArray *comments;

@end
