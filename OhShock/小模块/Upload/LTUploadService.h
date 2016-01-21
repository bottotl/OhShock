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
 *  上传的内容为 (NSAttributedString *)content 
    但是由于暂时没有做富文本的输入，这里就只做一个兼容性的处理，为了后期扩展成富文本提供便利
 */
@interface LTUploadService : NSObject

/**
*  上传图片
*
*  @param selectedAsset 选中的 PHAsset 数据
*  @param content       Post 文本
*  @param block         callback
*/
-(void)uploadPost:(NSArray <PHAsset *> *)selectedAsset andContent:(NSAttributedString *)content andBlock:(LTUploadResponse)block;

@end
