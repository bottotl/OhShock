//
//  LTPostImagesView.h
//  OhShock
//
//  Created by Lintao.Yu on 1/6/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LTPostImageCollectionViewCell.h"

@class LTPostImagesView;
@protocol LTPostImagesViewDelegate <UICollectionViewDelegate>
@required 
- (void)imagesView:(LTPostImagesView *)imagesView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

/**
 *  多图显示控件
 */
@interface LTPostImagesView : UIView

@property (nonatomic, strong) NSMutableDictionary      *thumbPhotos;///< 缩略图片数据(urlString) @{index:NSString}
@property (nonatomic, strong) NSMutableDictionary      *bigPhotos;///< 大图数据(urlString) @{index:NSString}

@property (nonatomic, weak  ) id <LTPostImagesViewDelegate > delegate;

/**
 *  配置 View
 *
 *  @param picNum    将要展示多少张图片
 *  @param needBig   是否需要显示大图
 *  @param itemSpace 图片间距
 *  @param limit     最多显示多少图片
 */
-(void)configViewWithPicNum:(NSUInteger)picNum needBig:(BOOL)needBig itemSpace:(CGFloat)itemSpace limit:(NSUInteger)limit;
- (UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  计算图片显示控件的高度
 *
 *  @param width  整个控件的预计宽度
 *  @param count  图片的数量
 *  @param bigpic 是否需要放大
 *  @param space  图片间距
 *  @param limit  最多显示多少张图片
 *
 *  @return 高度
 */
+ (CGFloat)heightWithSuggestThreePicWidth:(CGFloat)width andPicCount:(NSInteger)count andBigPic:(BOOL)bigpic andItemSpace:(CGFloat)space withLimit:(NSInteger)limit;


@end

