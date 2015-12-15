//
//  LTUserInfoSendMessageCell.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/15.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTUserInfoSendMessageCell.h"
#import "Masonry.h"
#import "ReactiveCocoa.h"


static CGFloat sendMessageButtonHeight = 80;
static CGFloat sendMessageButtonWidth = 200;

@interface LTUserInfoSendMessageCell ()
@property (nonatomic, strong) UIButton *sendMessageButton;
@property (nonatomic, assign) BOOL didSetupConstraints;
@end


@implementation LTUserInfoSendMessageCell

-(instancetype)init{
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LTUserInfoSendMessageCellIdentifier];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _sendMessageButton = [UIButton new];
        _sendMessageButton.backgroundColor = [UIColor greenColor];
        [_sendMessageButton setTitle:@"发送消息" forState:UIControlStateNormal];
        [_sendMessageButton setTintColor:[UIColor whiteColor]];
        _sendMessageButton.clipsToBounds = YES;
        [self.contentView addSubview:_sendMessageButton];
        _didSetupConstraints = false;
        
    }
    return self;
    
}

-(void)updateConstraints{
    if (!_didSetupConstraints) {
        [_sendMessageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(sendMessageButtonHeight));
            make.width.equalTo(@(sendMessageButtonWidth));
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(self.contentView.mas_topMargin).offset(20);
            make.bottom.equalTo(self.contentView.mas_bottomMargin);
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
    
    _sendMessageButton.layer.cornerRadius = _sendMessageButton.frame.size.height/2;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}
-(RACSignal *)rac_signalForSendMessageControlEvents{
    return [_sendMessageButton rac_signalForControlEvents:UIControlEventTouchUpInside];
}

@end
