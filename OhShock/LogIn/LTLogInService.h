//
//  LTLogInService.h
//  OhShock
//
//  Created by Lintao.Yu on 12/4/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LTLogInResponse)(BOOL);

@interface LTLogInService : NSObject

- (void)logInWithAccount:(NSString *)account password:(NSString *)password complete:(LTLogInResponse)completeBlock;

@end
