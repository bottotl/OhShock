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
-(void)setRightLabelText:(NSString *)rightLabelText{
    _rightLabel.text = rightLabelText;
}

-(NSString *)rightLabelText{
    return _rightLabel.text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}
-(void)layoutSubviews{
    [self.leftLabel sizeToFit];
    [self.rightLabel sizeToFit];
    self.leftImageView.size = CGSizeMake(40, 40);
    self.leftImageView.left = self.contentView.left + 10;
    self.leftImageView.centerY = self.contentView.centerY;
    self.leftLabel.left = self.leftImageView.right + 5;
    self.leftLabel.centerY = self.contentView.centerY;
    self.rightLabel.centerY = self.contentView.centerY;
    self.rightLabel.right = self.contentView.right - 20;
    
    [super layoutSubviews];
}

//-(void)updateConstraints{
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView.mas_top);
//        make.bottom.equalTo(self.contentView.mas_bottom);
//        make.width.equalTo(@40);
//        make.centerY.equalTo(self.contentView.mas_centerY);
//        make.left.equalTo(self.contentView.mas_left).offset(10);
//    }];
//    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.imageView.mas_right).offset(5);
//        make.centerY.equalTo(self.contentView.mas_centerY);
//        }];
//    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView.mas_right).offset(50);
//        make.centerY.equalTo(self.contentView.mas_centerY);
//        }];
//    [super updateConstraints];
//}

@end
