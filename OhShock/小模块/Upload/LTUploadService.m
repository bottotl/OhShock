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

-(void)uploadPost:(NSArray<PHAsset *> *)selectedAsset andContent:(NSString *)content andBlock:(LTUploadResponse)block{
    __block LTModelPost *post = [LTModelPost new];
    post.pubUser              = [LTModelUser currentUser];
    post.content              = content;
    
    NSUInteger countAll            = selectedAsset.count;
    __block NSUInteger count       = 0;
    __block NSMutableArray *photos = [NSMutableArray array];
    
    for (PHAsset * asset in selectedAsset) {
        [[PHImageManager defaultManager]requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            AVFile *file = [AVFile fileWithData:imageData];
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"file save succeeded");
                    [photos addObject:[AVFile fileWithData:imageData]];
                    count ++;
                    if (count == countAll) {
                        post.photos = photos;
                        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                NSLog(@"post sava succeeded");
                            }else{
                                NSLog(@"%@",error);
                            }
                        }];
                    }

                }else{
                    NSLog(@"%@",error);
                }
            }];
        }];
        
    }
}


@end
