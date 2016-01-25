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
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        __block LTModelPost *post = [LTModelPost new];
        post.pubUser              = [LTModelUser currentUser];
        post.content              = [content dataFromRange:NSMakeRange(0, content.length)
                                        documentAttributes:@{NSDocumentTypeDocumentAttribute : NSRTFTextDocumentType }
                                                     error:nil];
        NSMutableArray *thumbFiles = @[].mutableCopy;
        NSMutableArray *originFiles = @[].mutableCopy;
        
        PHImageRequestOptions *option = [PHImageRequestOptions new];
        option.synchronous = YES;
        option.version = PHImageRequestOptionsVersionCurrent;
        
        for (PHAsset * asset in selectedAsset) {
            [[PHImageManager defaultManager]requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                NSError *error = nil;
                
                UIImage *origin = [UIImage imageWithData:imageData];
                AVFile *originFile = [AVFile fileWithData:UIImageJPEGRepresentation(origin,0.6)];
                [originFiles addObject:originFile];
                if ([originFile save:&error]) {
                    NSLog(@"保存了一张原图");
                }else{
                    NSLog(@"保存原图失败 %@",error);
                }
                
                AVFile *thumbFile = [AVFile fileWithData:UIImageJPEGRepresentation(origin,0.2)];
                [thumbFiles addObject:thumbFile];
                if ([thumbFile save:&error]) {
                    NSLog(@"保存了一张缩略图");
                }else{
                    NSLog(@"保存缩略图失败 %@",error);
                }
            }];
        }
        post.thumbPhotos = thumbFiles;
        post.photos = originFiles;
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"保存 post 成功");
            }else{
                NSLog(@"post saveInBackground 失败 %@",error);
            }
            block(succeeded, error);
        }];

    });
    
}


@end
