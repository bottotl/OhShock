//
//  LTUploadService.m
//  OhShock
//
//  Created by Lintao.Yu on 1/15/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import "LTUploadService.h"
#import "LTModelPost.h"
#import "LTModelUser.h"

@implementation LTUploadService

-(void)uploadPost:(NSArray<UIImage *> *)images andContent:(NSString *)content andBlock:(LTUploadResponse)block{
    LTModelPost *post = [LTModelPost new];
    post.pubUser = [LTModelUser currentUser];
    post.content = content;
    
    NSMutableArray *photoFiles = [NSMutableArray array];
    NSError *theError;
    for (UIImage *photo in images) {
        AVFile *photoFile = [AVFile fileWithData:UIImageJPEGRepresentation(photo, 0.6)];
        [photoFile save:&theError];
        if (theError) {
            block(NO, theError);
            return;
        }
        [photoFiles addObject:photoFile];
    }
    post.photos = photoFiles;
    
    [post saveInBackgroundWithBlock:block];
}

@end
