//
//  LTMeLogOutCell.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/14.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTMeLogOutCell.h"
#import "Masonry.h"
#import "ReactiveCocoa.h"

@interface LTMeLogOutCell ()
@property (nonatomic, strong) UIButton *logOutButton;
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation LTMeLogOutCell
-(instancetype)init{
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LTMeLogOutCellIdentifier];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _logOutButton = [UIButton new];
        _logOutButton.backgroundColor = [UIColor redColor];
        [_logOutButton setTitle:@"退出" forState:UIControlStateNormal];
        [_logOutButton setTintColor:[UIColor whiteColor]];
        _logOutButton.clipsToBounds = YES;
        [self.contentView addSubview:_logOutButton];
        _didSetupConstraints = false;
        
    }
    return self;
    
}

-(void)updateConstraints{
    if (!_didSetupConstraints) {
        [_logOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.height.equalTo(@50);
            make.top.greaterThanOrEqualTo(self.contentView.mas_top).offset(20);
            make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom);
        }];
        _didSetupConstraints = YES;
    }
    [super updateConstraints];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    _logOutButton.layer.cornerRadius = _logOutButton.frame.size.height/2;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}
-(RACSignal *)rac_signalForLogOutControlEvents{
    return [_logOutButton rac_signalForControlEvents:UIControlEventTouchUpInside];
}


@end
