//
//  LTMeHeaderCell.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/22.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTMeHeaderCell.h"
#import "Masonry.h"
@interface LTMeHeaderCell ()
@property (nonatomic, strong)UIImageView *avatarImageView;
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation LTMeHeaderCell
- (instancetype)init
{
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LTMeHeaderCellIdentitier];
    return self;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _didSetupConstraints = false;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.text = @"头像";
        _avatarImageView = [UIImageView new];
        [self addSubview:_avatarImageView];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}
- (void)updateConstraints{
    if (!_didSetupConstraints) {
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(avatarHeight));
            make.width.equalTo(@(avatarWidth));
            make.right.equalTo(self.accessoryView.mas_left).offset(-5);
            make.centerY.equalTo(self.mas_centerY);
        }];
        _didSetupConstraints = YES;

    }
    
    [super updateConstraints];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


@end
