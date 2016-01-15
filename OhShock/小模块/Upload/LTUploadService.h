//
//  LTUploadService.h
//  OhShock
//
//  Created by Lintao.Yu on 1/15/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LTUploadResponse)(BOOL success, NSError *error);

@class UIImage;
@interface LTUploadService : NSObject

-(void)uploadPost:(NSArray <UIImage *> *)images andContent:(NSString *)content andBlock:(LTUploadResponse)block;

@end
