//
//  LTUploadAddPhotoColloectionCell.m
//  OhShock
//
//  Created by Lintao.Yu on 1/14/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import "LTUploadAddPhotoColloectionCell.h"
#import "UIView+Layout.h"

@interface LTUploadAddPhotoColloectionCell ()

@property (nonatomic, strong) UIButton *addPhotoButton;

@end

@implementation LTUploadAddPhotoColloectionCell

-(UIButton *)addPhotoButton{
    if (!_addPhotoButton) {
        _addPhotoButton = [UIButton new];
        [_addPhotoButton setImage:[UIImage imageNamed:@"addPictureBgImage"] forState:UIControlStateNormal];
        [self.contentView addSubview:_addPhotoButton];
    }
    return _addPhotoButton;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.addPhotoButton.frame = self.bounds;
}

@end
