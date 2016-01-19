//
//  LTAddTodoSelectionCell.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/24.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTAddTodoSelectionCell.h"
#import "UIView+Layout.h"
@interface LTAddTodoSelectionCell(){
    BOOL needUpdateConstraints;
}
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UILabel *leftLabel;
@property (strong, nonatomic) UILabel *rightLabel;


@end

@implementation LTAddTodoSelectionCell

-(instancetype)init{
    
    return self;
}
-(instancetype)initWithImage:(UIImage *)image leftText:(NSString *)leftText rightText:(NSString *)rightText{
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LTAddTodoSelectionCellIdentifier];
    self.leftImageView.image = image;
    self.leftLabel.text = leftText;
    self.rightLabel.text = rightText;
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        needUpdateConstraints = NO;
        self.leftImageView = [UIImageView new];
        self.leftLabel = [UILabel new];
        self.rightLabel = [UILabel new];
        
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.rightLabel];
        [self.contentView addSubview:self.leftImageView];
    }
    return self;
}

-(void)ConfigeCell:(UIImage *)image leftText:(NSString *)leftText rightText:(NSString *)rightText{
    self.leftImageView.image = image;
    self.leftLabel.text = leftText;
    self.rightLabel.text = rightText;
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

-(void)setRightText:(NSString *)rightText{
    _rightText = rightText;
    _rightLabel.text = rightText;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}
-(void)layoutSubviews{
    [self.leftLabel sizeToFit];
    [self.rightLabel sizeToFit];
    if (self.leftImageView.image) {
        self.leftImageView.size = CGSizeMake(40, 40);
        self.leftImageView.left = self.contentView.left + 10;
        self.leftImageView.centerY = self.contentView.centerY;
        
        self.leftLabel.left = self.leftImageView.right + 5;
        self.leftLabel.centerY = self.contentView.centerY;
        self.rightLabel.centerY = self.contentView.centerY;
        self.rightLabel.right = self.contentView.right - 20;
    }else{
        self.leftLabel.left =  15;
        self.leftLabel.centerY = self.contentView.centerY;
        
        self.rightLabel.centerY = self.contentView.centerY;
        self.rightLabel.right = self.contentView.right - 20;
    }
    
    
    [super layoutSubviews];
}

@end
