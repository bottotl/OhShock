//
//  LTMeHeadView.m
//  OhShock
//
//  Created by Lintao.Yu on 12/8/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTMeHeadView.h"
#import "UIView+Layout.h"
#import "LTMeHeadUserImageView.h"
#import "LTMeHeadUserInfoView.h"
#import "ReactiveCocoa.h"
#import "UIImageView+WebCache.h"
#import "LTMeHeadUserFollowerAndFolloweeView.h"

@interface LTMeHeadView()

@property (nonatomic, strong) LTMeHeadUserImageView *userAvator;
@property (nonatomic, strong) LTMeHeadUserInfoView *userInfo;
@property (nonatomic, strong) LTMeHeadUserFollowerAndFolloweeView *followInfoView;

@end

@implementation LTMeHeadView

- (instancetype)init
{
    self = [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, LTMeHeadViewHeight)];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _userAvator = [[LTMeHeadUserImageView alloc]init];
        _userAvator.contentMode = UIViewContentModeScaleAspectFit;
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

-(void)layoutSubviews{
    [super layoutSubviews];
    self.followInfoView.width = self.width;
    self.followInfoView.height = 20;
    self.followInfoView.bottom = self.bottom - 10;
    self.followInfoView.centerX = self.bounds.size.width/2;
    
    self.userInfo.bottom = self.followInfoView.top - 10;
    self.userInfo.centerX = self.bounds.size.width/2;
    
    self.userAvator.bottom = self.userInfo.top - 10 ;
    self.userAvator.centerX = self.bounds.size.width/2;
    
    
    
}

@end
