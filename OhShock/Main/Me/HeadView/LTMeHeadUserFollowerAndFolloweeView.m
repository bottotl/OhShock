//
//  LTMeHeadUserFollowerAndFolloweeView.m
//  OhShock
//
//  Created by Lintao.Yu on 12/9/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTMeHeadUserFollowerAndFolloweeView.h"
#import "LTMeHeadUserFollowInfoView.h"
#import "UIView+Layout.h"


@interface LTMeHeadUserFollowerAndFolloweeView ()
/// 关注按钮
@property (nonatomic, strong) LTMeHeadUserFollowInfoView *followeeInfoLabel;
/// 粉丝按钮
@property (nonatomic, strong) LTMeHeadUserFollowInfoView *followerInfoLabel;
/// 中间的分割线
@property (nonatomic, strong) UIView *lineView;

@end

@implementation LTMeHeadUserFollowerAndFolloweeView

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        _followeeInfoLabel = [LTMeHeadUserFollowInfoView new];
        _followeeInfoLabel.info = @"关注";
        _followeeInfoLabel.num = 0;
        [self addSubview:_followeeInfoLabel];
        
        _followerInfoLabel = [LTMeHeadUserFollowInfoView new];
        _followerInfoLabel.info = @"粉丝";
        _followerInfoLabel.num = 0;
        [self addSubview:_followerInfoLabel];
        
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_lineView];
    }
    return self;
}

-(void)setFolloweeNum:(NSInteger )followeeNum{
    _followeeNum = followeeNum;
    self.followeeInfoLabel.num = followeeNum;
}

-(void)setFollowerNum:(NSInteger)followerNum{
    _followerNum = followerNum;
    self.followerInfoLabel.num = followerNum;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.lineView.height = self.height;
    self.lineView.width = 2;
    self.lineView.centerY = self.bounds.size.height / 2;
    self.lineView.centerX = self.bounds.size.width /2;
    
    self.followeeInfoLabel.centerY = self.bounds.size.height / 2;
    self.followeeInfoLabel.right = self.lineView.left;
    
    self.followerInfoLabel.centerY = self.bounds.size.height /2;
    self.followerInfoLabel.left = self.lineView.right;
}

-(RACSignal *)rac_followeeOnclickSignal{
    return [self.followeeInfoLabel rac_OnClickSignal];
}
-(RACSignal *)rac_followerOnclickSignal{
    return [self.followerInfoLabel rac_OnClickSignal];
    
}

@end
