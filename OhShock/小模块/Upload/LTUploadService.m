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
    
    [[PHImageManager defaultManager]requestImageForAsset:selectedAsset[0] targetSize:CGSizeMake(80, 80)  contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info){

    }];
    for (PHAsset * asset in selectedAsset) {
//        [[PHImageManager defaultManager]requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//            NSLog(@"result is :%@",result);
////            AVFile *photoFile = [AVFile fileWithData:info];
////            [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
////                if(succeeded){
////                    [photos addObject:photoFile];
////                    count ++;
////                    if (count == countAll) {
//////                        post.photos = photos.copy;
//////                        [post saveInBackgroundWithBlock:block];
////                    }
////                }else{
////                    NSLog(@"photoFile save %@",error);
////                }
////            }];
//
//        }];
        
    }
}
@end
