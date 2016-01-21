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
    NSMutableArray *photos = [NSMutableArray array];
    PHImageRequestOptions *option = [PHImageRequestOptions new];
    option.synchronous = YES;
    option.version = PHImageRequestOptionsVersionCurrent;
    for (PHAsset * asset in selectedAsset) {
        [[PHImageManager defaultManager]requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            AVFile *file = [AVFile fileWithData:imageData];
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"file save succeeded");
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
