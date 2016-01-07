//
//  LTPostImagesView.h
//  OhShock
//
//  Created by Lintao.Yu on 1/6/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  标记了图片展示的样式
 */
typedef NS_ENUM(NSUInteger, LTPostImagesViewType) {
    /**
     *  大图
     */
    LTPostImagesViewTypeBig,
    /**
     *  小图
     */
    LTPostImagesViewTypeReport
};

@interface LTPostImagesView : UIView

@property (nonatomic, strong) NSArray *images;///< @[<imageUrlString>]

@property (nonatomic, assign) LTPostImagesViewType type;

+(CGFloat)viewHeightWithImages:(NSArray *)images;

@end
static NSString *LTPostImagesCollectionViewCellIdentifier = @"LTPostImagesCollectionViewCell";
@interface LTPostImagesCollectionViewCell : UICollectionViewCell

@end
