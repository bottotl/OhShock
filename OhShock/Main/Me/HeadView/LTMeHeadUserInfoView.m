//
//  LTMeHeadUserInfoView.m
//  OhShock
//
//  Created by Lintao.Yu on 12/8/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTMeHeadUserInfoView.h"
#import "UIView+Layout.h"
#import "Masonry.h"


static NSString *MaleImageName = @"jft0m";
static NSString *FemaleImageName = @"jft0m";
static NSString *UnKnowImageName = @"jft0m";
@interface LTMeHeadUserInfoView ()

@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIImageView *userSexIcon;

@end

@implementation LTMeHeadUserInfoView

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, LTMeHeadUserInfoViewHeight, LTMeHeadUserInfoViewHeight)];
    if (self) {
        _userNameLabel = [UILabel new];
        _userNameLabel.textAlignment = NSTextAlignmentCenter;
        [_userNameLabel setTintColor:[UIColor blackColor]];
        [self addSubview:_userNameLabel];
        
        _userSexIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:_userSexIcon];
    }
    return self;
}

- (void)setUserName:(NSString *)userName{
    _userName = userName;
    self.userNameLabel.text = userName;
    [self sizeToFit];
}

-(void)setFrame:(CGRect)frame{
    frame = CGRectMake(frame.origin.x, frame.origin.y, LTMeHeadUserInfoViewWidth, LTMeHeadUserInfoViewHeight);
    [super setFrame:frame];
}

-(void)setUserSex:(LTMeHeadUserSex)userSex{
    _userSex = userSex;
    NSString *imageName;
    switch (userSex) {
        case Male:
            imageName = MaleImageName;
            break;
        case Female:
            imageName = FemaleImageName;
            break;
        case UnKnow:
            imageName = UnKnowImageName;
            break;
        default:
            break;
    }
    self.userSexIcon.image = [UIImage imageNamed:imageName];
}

-(void)updateConstraints{
    
    [self.userSexIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(@(LTMeHeadUserInfoSexImageHeight));
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.userSexIcon.mas_left);
    }];
    
    [super updateConstraints];
}

@end
