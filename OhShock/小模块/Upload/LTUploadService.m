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
    __block LTModelPost *post = [LTModelPost new];
    post.pubUser              = [LTModelUser currentUser];
    post.content              = content;
    
    NSUInteger countAll            = images.count;
    __block NSUInteger count       = 0;
    __block NSMutableArray *photos = [NSMutableArray array];
    
    for (UIImage *image in images) {
        AVFile *photoFile = [AVFile fileWithData:UIImagePNGRepresentation(image)];
        [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                [photos addObject:photoFile];
                count ++;
                if (count == countAll) {
                    post.photos = photos.copy;
                    [post saveInBackgroundWithBlock:block];
                }
            }else{
                NSLog(@"photoFile save %@",error);
            }
        }];
    }
    
    
}

@end
