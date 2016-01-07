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

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, MScreenWidth, 0)];
    if (self) {
        _contentLabel = [YYLabel new];
        [self addSubview:_contentLabel];
    }
    return self;
}

#pragma mark - layout
-(void)layoutSubviews{
    
    self.size = CGSizeMake(MScreenWidth, self.height);
    
    self.contentLabel.top = 0;
    self.contentLabel.centerX = self.width/2;
    
    [super layoutSubviews];
}

#pragma mark - property
-(void)setContent:(NSAttributedString *)content{
    _content = content;
    CGSize size = CGSizeMake(MScreenWidth - LTPostContentLabelPadding * 2, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:content];
    self.contentLabel.size = layout.textBoundingSize;
    self.contentLabel.textLayout = layout;
}

-(CGFloat)height{
    CGSize size = CGSizeMake(MScreenWidth - LTPostContentLabelPadding * 2, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:self.content];
    return layout.textBoundingSize.height;
}

#pragma mark - 根据文字内容获取高度
+(CGFloat)viewHeightWithContent:(NSAttributedString *)content width:(CGFloat)width{
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:content];
    return layout.textBoundingSize.height;
}

@end
