//
//  LTTapImageView.h
//  OhShock
//
//  Created by Lintao.Yu on 12/8/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTTapImageView : UIImageView

typedef void (^UITapImageViewTapBlock)(__nullable id obj);
/**
 *  @author Lintao Yu, 15-12-08 16:12:01
 *
 *  设定图片点击后的回调block
 */
@property (nullable, nonatomic, copy) UITapImageViewTapBlock tapAction;

/**
 *  @author Lintao Yu, 15-12-08 16:12:35
 *
 *  设定图片内容
 *
 *  @param imgUrl           图片的地址
 *  @param placeholderImage 旧的图片（没有缓存时用的图片）
 *  @param tapAction        点击图片后回调的block
 */
-(void)setImageWithUrl:(nullable NSURL *)imgUrl placeholderImage:(nullable UIImage *)placeholderImage tapBlock:(nullable UITapImageViewTapBlock)tapAction;

@end
