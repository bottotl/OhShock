//
//  LTUserInfoFollowButton.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/15.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTUserInfoFollowButton.h"

@implementation LTUserInfoFollowButton
- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect rect = CGRectMake(frame.origin.x, frame.origin.y, LTUserInfoFollowButtonWidth, LTUserInfoFollowButtonHeight);
    self = [super initWithFrame:rect];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor greenColor];
        [self setTitle:@"关注" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

-(void)setType:(LTUserInfoFollowButtonType )type{
    _type = type;
    [self setButtonTyoeWithType:_type];
}

-(void)setButtonTyoeWithType:(LTUserInfoFollowButtonType)type{
    NSString *imageName;
    
    switch (type) {
        case followedType:
            imageName = @"n_btn_followed_yes";
            break;
        case bothFollowType:
            imageName = @"n_btn_followed_both";
            break;
        case notFollowType:
            imageName = @"n_btn_followed_not";
            break;
        default:
            break;
    }
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

-(void)layoutSubviews{
    self.layer.cornerRadius = self.frame.size.height /2;
    [super layoutSubviews];
}

@end
