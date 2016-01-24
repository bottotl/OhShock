//
//  LTUploadPhotoCollectionCell.m
//  OhShock
//
//  Created by lintao.yu on 16/1/14.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTUploadPhotoCollectionCell.h"
#import "UIView+Layout.h"

@interface LTUploadPhotoCollectionCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation LTUploadPhotoCollectionCell

#pragma mark - property

-(void)setImage:(UIImage *)image{
    self.imageView.image = image;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

#pragma mark - layout

-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}


#pragma mark - 配置 Cell 数据

-(void)configCellWith:(UIImage *)image{
    self.image = image;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
