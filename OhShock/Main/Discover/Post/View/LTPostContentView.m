//
//  LTPostContentView.m
//  OhShock
//
//  Created by Lintao.Yu on 16/1/5.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTPostContentView.h"
#import "YYKit.h"
#import "UIView+Layout.h"

@interface LTPostContentView ()

@property (nonatomic, strong) YYLabel *contentLabel;


@end

@implementation LTPostContentView

#pragma mark - layout
-(void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark - sizeToFit
-(CGSize)sizeThatFits:(CGSize)size{
    [self setContent:self.content];
    return self.contentLabel.size;
}


#pragma mark - property

#pragma mark View
-(YYLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [YYLabel new];
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}

#pragma mark Data

-(void)setContent:(NSAttributedString *)content{
    _content = content;
    CGSize size = CGSizeMake(self.width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:content];
    self.contentLabel.size = layout.textBoundingSize;
    self.contentLabel.textLayout = layout;
}

#pragma mark - 高度计算
+(CGFloat)heightWithContent:(NSAttributedString *)content andPreferedWidth:(CGFloat)width{
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:content];
    return layout.textBoundingSize.height;
}

@end
