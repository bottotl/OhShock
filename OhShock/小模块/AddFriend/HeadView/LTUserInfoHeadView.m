//
//  LTUserInfoHeadView.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/15.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTUserInfoHeadView.h"

@implementation LTUserInfoHeadView
- (instancetype)init
{
    self = [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, LTUserInfoHeadViewHeight)];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        _followButton = [LTUserInfoFollowButton new];
        [self addSubview:_followButton];
        _userAvator = [[LTMeHeadUserImageView alloc]init];
        _userAvator.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_userAvator];
        
        
        _userInfo = [LTMeHeadUserInfoView new];
        [self addSubview:_userInfo];
        [_userInfo setUserName:@"jft0m"];
        [_userInfo setUserSex:Male];
        
        _followInfoView = [LTMeHeadUserFollowerAndFolloweeView new];
        [self addSubview:_followInfoView];
        
        [RACObserve(self, avatorUrlString) subscribeNext:^(NSString *avatorUrlString) {
            NSLog(@"%@",avatorUrlString);
            self.userAvator.avatorUrlString = avatorUrlString;
        }];
        
        [RACObserve(self.userAvator, image) subscribeNext:^(UIImage *avator) {
            self.image = avator;
            [self setNeedsLayout];
        }];
    }
    return self;
}
- (void)setFollowType:(LTUserInfoFollowButtonType)followType{
    self.followButton.type = followType;
}

-(RACSignal *)rac_avatorTapGesture{
    return [_userAvator rac_gestureSignal];
}

-(RACSignal *)rac_followeeTapGesture{
    return [_followInfoView rac_followeeOnclickSignal];
}
-(RACSignal *)rac_followerTapGesture{
    return [_followInfoView rac_followerOnclickSignal];
}
-(RACSignal *)rac_followButtonOnClick{
    return [self.followButton rac_signalForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - property
-(void)setFolloweeNum:(NSInteger)followeeNum{
    _followeeNum = followeeNum;
    self.followInfoView.followeeNum = followeeNum;
}
-(void)setFollowerNum:(NSInteger)followerNum{
    _followerNum = followerNum;
    self.followInfoView.followerNum = followerNum;
}
-(void)setFollowButoonType:(LTUserInfoFollowButtonType)followButoonType{
    _followButoonType = followButoonType;
    self.followButton.type = followButoonType;
}
#pragma mark -  布局
-(void)layoutSubviews{
    [super layoutSubviews];
    self.followInfoView.width = self.width;
    self.followInfoView.height = 20;
    self.followInfoView.bottom = self.bottom - 10;
    self.followInfoView.centerX = self.bounds.size.width/2;
    
    self.followButton.centerX = self.bounds.size.width/2;
    self.followButton.bottom = self.followInfoView.top - 10;
    
    self.userInfo.bottom = self.followButton.top - 10;
    self.userInfo.centerX = self.bounds.size.width/2;
    
    self.userAvator.bottom = self.userInfo.top - 10 ;
    self.userAvator.centerX = self.bounds.size.width/2;
}

@end
