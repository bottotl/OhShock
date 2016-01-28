//
//  LTUploadTextAndPhotosCell.m
//  OhShock
//
//  Created by lintao.yu on 16/1/14.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTUploadTextAndPhotosCell.h"
#import "LTUploadTextAndPhotosView.h"

@interface LTUploadTextAndPhotosCell ()



@end

@implementation LTUploadTextAndPhotosCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _richView = [LTUploadTextAndPhotosView new];
        [self addSubview:_richView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.richView.width = self.width;
    [self.richView sizeToFit];
    self.richView.left = 0;
    self.richView.top = 0;
}

-(void)configCell:(NSArray *)photos{
    [self.richView configView:photos];
}

+(CGFloat)cellHeightWithPhotoCount:(NSInteger)photoCount andWidth:(CGFloat)width{
    return [LTUploadTextAndPhotosView heightWithPhotoCount:photoCount andPreferedViewWidth:width];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}

@end
