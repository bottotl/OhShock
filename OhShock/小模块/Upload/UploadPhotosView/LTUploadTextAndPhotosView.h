//
//  LTUploadTextAndPhotosView.h
//  OhShock
//
//  Created by lintao.yu on 16/1/14.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYControl.h"

/// 添加图片按钮的点击
@protocol LTUploadTextAndPhotosViewDelegae <NSObject>
@required
- (void)addPhotoOnClick;
@end

/**
 *  仿微信的发朋友圈的文字输入框（包含图片展示和选择框）
 */
@interface LTUploadTextAndPhotosView : UIView

@property (nonatomic, strong) id <LTUploadTextAndPhotosViewDelegae> delegate;
@property (nonatomic, strong) YYTextView *textView;

-(void)configView:(NSArray *)photos;

+(CGFloat)heightWithPhotoCount:(NSInteger)photoCount andPreferedViewWidth:(CGFloat)viewWidth;

@end


