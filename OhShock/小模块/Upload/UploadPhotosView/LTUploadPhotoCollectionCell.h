//
//  LTUploadPhotoCollectionCell.h
//  OhShock
//
//  Created by lintao.yu on 16/1/14.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const LTUploadPhotoCollectionCellIdentifier = @"LTUploadPhotoCollectionCell";

/**
 *  显示一张图片
 */
@interface LTUploadPhotoCollectionCell : UICollectionViewCell

-(void)configCellWith:(UIImage *)image;

@end
