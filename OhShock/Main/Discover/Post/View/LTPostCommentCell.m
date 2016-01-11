//
//  LTPostCommentCell.m
//  OhShock
//
//  Created by Lintao.Yu on 1/10/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import "LTPostCommentCell.h"
#import "YYKit.h"
#import "UIView+Layout.h"

@interface LTPostCommentCell ()

@property (nonatomic, strong) YYLabel *commentLabel;

@end

@implementation LTPostCommentCell

-(void)configCellWithAttributedString:(NSAttributedString *)string{
    self.commentLabel.attributedText = string;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.commentLabel.frame = self.contentView.bounds;
    
}

-(YYLabel *)commentLabel{
    if (!_commentLabel) {
        _commentLabel = [YYLabel new];
        _commentLabel.numberOfLines = 0;
        _commentLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_commentLabel];
    }
    return _commentLabel;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:NO animated:animated];
}

#pragma mark - 计算高度
+ (CGFloat)heightWithAttributedString:(NSAttributedString *)string andWidth:(CGFloat)width{
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:string];
    return layout.textBoundingSize.height + 7;
}

@end
