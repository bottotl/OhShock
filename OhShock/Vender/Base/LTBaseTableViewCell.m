//
//  LTBaseTableViewCell.m
//  OhShock
//
//  Created by lintao.yu on 16/1/14.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTBaseTableViewCell.h"
#import "UIView+Layout.h"
#import "UIColor+expanded.h"
static CGFloat const LTCellHeight = 60;
static CGFloat const ShowTitleLabelWidth = 180;
static CGFloat const AccessoryTextLabelWidth = 30;
static CGFloat const AccessoryTextLabelRightPadding = 20;

@interface LTBaseTableViewCell ()

/// 左边的图片
@property (nonatomic, strong) UIImageView *showImageView;

/// 左边的文字
@property (nonatomic, strong) UILabel *showTitleLabel;

/// 右边的文字
@property (nonatomic, strong) UILabel *accessoryTextLabel;

@end

@implementation LTBaseTableViewCell
@synthesize showImage = _showImage, showTitle = _showTitle, accessoryText = _accessoryText;
#pragma mark - init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)ConfigCell:(UIImage *)showImage andTitle:(NSString *)showTitle andaccessoryText:(NSString *)accessoryText{
    self.showImage = showImage;
    self.showTitle = showTitle;
    self.accessoryText = accessoryText;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - property

#pragma mark 数据
- (void)setShowImage:(UIImage *)showImage{
    _showImage = showImage;
    self.showImageView.image = showImage;
//    if (self.showImageView) {
//        
//    }
}

-(void)setAccessoryText:(NSString *)accessoryText{
    _accessoryText = accessoryText;
    self.accessoryTextLabel.text = accessoryText;
//    if (self.accessoryTextLabel) {
//        
//    }
}

-(void)setShowTitle:(NSString *)showTitle{
    _showTitle = showTitle;
    self.showTitleLabel.font = [UIFont systemFontOfSize:16];
    self.showTitleLabel.textColor = [UIColor colorWithHexString:@"a8a8aa"];
    self.showTitleLabel.text = showTitle;

}

-(UIImage *)showImage{
    return self.showImageView.image;
}

-(NSString *)showTitle{
    return self.showTitleLabel.text;
}

#pragma mark 控件
-(UIImageView *)showImageView{
    if (!_showImageView) {
        _showImageView = [UIImageView new];
        [self.contentView addSubview:_showImageView];
    }
    return _showImageView;
}
-(UILabel *)showTitleLabel{
    if (!_showTitleLabel) {
        _showTitleLabel = [UILabel new];
        _showTitleLabel.numberOfLines = 1;
        [self.contentView addSubview:_showTitleLabel];
    }
    return _showTitleLabel;
}
-(UILabel *)accessoryTextLabel{
    if (!_accessoryTextLabel) {
        _accessoryTextLabel = [UILabel new];
        _accessoryTextLabel.numberOfLines = 1;
        [self.contentView addSubview:_accessoryTextLabel];
    }
    return _accessoryTextLabel;
}

#pragma mark - layout

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat left = 30;
    if (self.showImage) {
        self.showImageView.height = 30;
        self.showImageView.width = self.showImageView.height;
        self.showImageView.left = left;
        self.showImageView.centerY = self.height/2;
        left += self.showImageView.width;
    }
    if (self.showTitle) {
        left += 25;
        self.showTitleLabel.width = ShowTitleLabelWidth;
        self.showTitleLabel.height = self.height;
        self.showTitleLabel.left = left;
//        left += self.showTitleLabel.width;
    }
    if (self.accessoryText) {
        self.accessoryTextLabel.width  = AccessoryTextLabelWidth;
        self.accessoryTextLabel.height = self.height;
        self.accessoryTextLabel.right  = self.width - AccessoryTextLabelRightPadding;
    }
}


#pragma mark - 选中效果
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}

#pragma mark - 计算高度

+(CGFloat)CellHeight {
    return LTCellHeight;
}
@end
