//
//  LTUploadService.h
//  OhShock
//
//  Created by Lintao.Yu on 1/15/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void (^LTUploadResponse)(BOOL success, NSError *error);


/**
 *  提供了上传 post 所需的接口
 */
@interface LTUploadService : NSObject

/**
*  上传图片
*
*  @param selectedAsset 选中的 PHAsset 数据
*  @param content       Post 文本
*  @param block         callback
*/
-(void)uploadPost:(NSArray <PHAsset *> *)selectedAsset andContent:(NSString *)content andBlock:(LTUploadResponse)block;

@end
