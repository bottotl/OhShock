//
//  LTUploadTextAndPhotosView.h
//  OhShock
//
//  Created by lintao.yu on 16/1/14.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
/// 添加图片按钮的点击
@protocol AddPhotoDelegae <NSObject>
@required
- (void)addPhotoOnClick;
@end

/**
 *  仿微信的发朋友圈的文字输入框（包含图片展示和选择框）
 */
@interface LTUploadTextAndPhotosView : UIView

@property (nonatomic, strong) id <AddPhotoDelegae> delegate;
@property (nonatomic, strong) id <UITextViewDelegate> textViewDelegate;

+(CGFloat)photoHeight;// 图片展示的大小

-(void)configView:(NSArray *)photos;

+(CGFloat)heightWithPhotos:(NSArray *)photos;

@end


