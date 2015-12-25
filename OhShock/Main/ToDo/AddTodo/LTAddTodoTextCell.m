//
//  LTAddTodoTextCell.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/24.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTAddTodoTextCell.h"
#import "Masonry.h"
@interface LTAddTodoTextCell(){
    BOOL needUpdateConstrains;
}
@property (nonatomic, strong) UITextView *textView;
@end
@implementation LTAddTodoTextCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textView = [UITextView new];
        self.textView.clipsToBounds = YES;
        self.textView.userInteractionEnabled = YES;
        needUpdateConstrains = YES;
        [self.contentView addSubview:self.textView];
    }
    
    return self;
}
-(void)updateConstraints{
    if (needUpdateConstrains) {
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.top.equalTo(self.contentView.mas_top);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        needUpdateConstrains = NO;
    }
    [super updateConstraints];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
-(void)layoutSubviews{
    //self.textView.layer.cornerRadius = 10;
    [super layoutSubviews];
}

@end
