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

@property (nonatomic, strong) LTUploadTextAndPhotosView *richView;

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
    self.richView.frame = self.bounds;
}

-(void)configCell:(NSArray *)photos{
    [self.richView configView:photos];
}

+(CGFloat)cellHeight:(NSArray *)photos{
    return [LTUploadTextAndPhotosView heightWithPhotos:photos];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}

@end
