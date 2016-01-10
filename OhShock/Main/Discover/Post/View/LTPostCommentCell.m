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
//    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:self.contentView.size text:self.commentLabel.attributedText];
//    self.commentLabel.size = layout.textBoundingSize;
    self.commentLabel.frame = self.contentView.bounds;
    
}

-(YYLabel *)commentLabel{
    if (!_commentLabel) {
        _commentLabel = [YYLabel new];
        _commentLabel.numberOfLines = 0;
        [self.contentView addSubview:_commentLabel];
    }
    return _commentLabel;
}

+ (CGFloat)heightWithAttributedString:(NSAttributedString *)string andWidth:(CGFloat)width{
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:string];
    return layout.textBoundingSize.height;
}

@end
