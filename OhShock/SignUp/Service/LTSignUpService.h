//
//  LTSignUpService.h
//  OhShock
//
//  Created by Lintao.Yu on 12/4/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^LTSignUpResponse)(BOOL succeeded, NSError * _Nullable error);
@interface LTSignUpService : NSObject

- (void)signUpWithAccount:(nonnull NSString *)account password:(nonnull NSString *)password email:(nullable NSString *)email phone:(nullable NSString *)phone complete:(nullable LTSignUpResponse)completeBlock;

@end
