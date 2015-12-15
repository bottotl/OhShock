//
//  LTUserSearchService.h
//  OhShock
//
//  Created by Lintao.Yu on 15/12/15.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVUser;
typedef void (^LTFindUsersResponse)(NSArray *users, NSError *error);

@interface LTUserSearchService : NSObject

- (void)findUsersByPartname:(NSString *)partName complete:(LTFindUsersResponse)completeBlock;
@end
