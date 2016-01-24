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
#import "YYKit.h"


@implementation LTUploadService

-(void)uploadPost:(NSArray<PHAsset *> *)selectedAsset andContent:(NSAttributedString *)content andBlock:(LTUploadResponse)block{
    __block LTModelPost *post = [LTModelPost new];
    post.pubUser              = [LTModelUser currentUser];
    post.content              = [content dataFromRange:NSMakeRange(0, content.length)
                                    documentAttributes:@{NSDocumentTypeDocumentAttribute : NSRTFTextDocumentType }
                                                error:nil];
    
    NSUInteger countAll            = selectedAsset.count;
    __block NSUInteger count       = 0;
    __block NSUInteger thumbCount  = 0;
    NSMutableArray *photos = [NSMutableArray array];
    NSMutableArray *thumbPhotos = [NSMutableArray array];
    PHImageRequestOptions *option = [PHImageRequestOptions new];
    option.synchronous = YES;
    option.version = PHImageRequestOptionsVersionCurrent;
    for (PHAsset * asset in selectedAsset) {
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(300, 300) contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            AVFile *file = [AVFile fileWithData:UIImagePNGRepresentation(result) ];
            NSLog(@"缩略图加载完成");
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"缩略图 save succeeded");
                    [thumbPhotos addObject:file];
                    thumbCount ++;
                    if (thumbCount == countAll ) {
                        post.thumbPhotos = thumbPhotos;
                        @weakify(self);
                        [weak_self uploadPostWithPost:post andBlock:^(BOOL success, NSError *error) {
                            if (success) {
                                NSLog(@"uploadPostWithPost success");
                                
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

        [[PHImageManager defaultManager]requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            AVFile *file = [AVFile fileWithData:imageData];
            NSLog(@"原图加载完成");
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"原图 save succeeded");
                    [photos addObject:file];
                    count ++;
                    if (count == countAll) {
                        post.photos = photos;
                        @weakify(self);
                        [weak_self uploadPostWithPost:post andBlock:^(BOOL success, NSError *error) {
                            if (success) {
                                NSLog(@"uploadPostWithPost success");
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


-(void)uploadPostWithPost:(LTModelPost *)post andBlock:(LTUploadResponse)block{
    if(post){
//        NSMutableArray *array = @[].mutableCopy;
//        for(int i = 0 ;i<60;i++){
//            LTModelPost *p_post = [LTModelPost new];
//            p_post.pubUser = post.pubUser;
//            p_post.thumbPhotos = post.thumbPhotos;
//            p_post.content = post.content;
//            p_post.photos = post.photos;
//            [array addObject:p_post];
//        }
//        [LTModelPost saveAllInBackground:array block:^(BOOL succeeded, NSError *error) {
//            if (succeeded) {
//                NSLog(@"saveAllInBackground succeeded");
//            }
//        }];
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"post sava succeeded");
            }else{
                NSLog(@"%@",error);
            }
        }];
    }else{
        block(NO,nil);
    }
    
}

@end
