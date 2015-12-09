//
//  LTMeHeadUserFollowerAndFolloweeView.m
//  OhShock
//
//  Created by Lintao.Yu on 12/9/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTMeHeadUserFollowerAndFolloweeView.h"
#import "LTMeHeadUserFollowInfoView.h"

static CGFloat viewOffset = 5.0;
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
    
    self = [super initWithFrame:CGRectMake(0, 0, LTMeHeadUserFollowerAndFolloweeViewWidth, LTMeHeadUserFollowerAndFolloweeViewHeight)];
    if (self) {
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

- (void)updateConstraints{
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@2);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(self);
    }];
    
    [self.followeeInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
        make.right.equalTo(self.lineView.mas_left).offset(-viewOffset);
    }];
    
    [self.followerInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self);
        make.left.equalTo(self.lineView.mas_right).offset(viewOffset);
    }];
    
    [super updateConstraints];
}

@end
