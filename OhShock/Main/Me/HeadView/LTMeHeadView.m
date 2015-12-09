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

@interface LTMeHeadView()

@property (nonatomic, strong) LTMeHeadUserImageView *userAvator;
@property (nonatomic, strong) LTMeHeadUserInfoView *userInfo;
@property (nonatomic, strong) UIImageView *backgroudImageView;

@end

@implementation LTMeHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _backgroudImageView = [UIImageView new];
        [self addSubview:_backgroudImageView];
        
        _userAvator = [[LTMeHeadUserImageView alloc]init];
        _userAvator.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_userAvator];
        
        _userInfo = [LTMeHeadUserInfoView new];
        
        
    }
    [RACObserve(self, avatorUrlString) subscribeNext:^(NSString *avatorUrlString) {
        NSLog(@"%@",avatorUrlString);
        self.userAvator.avatorUrlString = avatorUrlString;
    }];
    
    [RACObserve(self.userAvator, image) subscribeNext:^(UIImage *avator) {
        self.backgroudImageView.image = avator;
    }];
    
    return self;
}

-(void)layoutSubviews{
    
    self.backgroudImageView.frame = self.bounds;
    
    self.userAvator.top = self.top;
    self.centerX = self.bounds.size.width/2;
    
}

@end
