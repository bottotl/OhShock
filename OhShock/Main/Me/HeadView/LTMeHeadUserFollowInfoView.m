//
//  LTMeHeadUserFollowInfoView.m
//  OhShock
//
//  Created by Lintao.Yu on 12/9/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTMeHeadUserFollowInfoView.h"
#import "UIView+Layout.h"

@interface LTMeHeadUserFollowInfoView ()

@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation LTMeHeadUserFollowInfoView

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:CGRectMake(0, 0, LTMeHeadUserFollowInfoViewWidth, LTMeHeadUserFollowInfoViewHeight)];
    if (self) {
        _numLabel = [UILabel new];
        _numLabel.textColor = [UIColor whiteColor];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_numLabel];
        
        _infoLabel = [UILabel new];
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_infoLabel];
        
    }
    return self;
}

-(void)setNum:(NSInteger)num{
    _num = num;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",_num];
    [self setNeedsUpdateConstraints];
}

-(void)setInfo:(NSString *)info{
    _info = info.copy;
    self.infoLabel.text = _info;
    [self setNeedsUpdateConstraints];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.numLabel.size = CGSizeMake(LTMeHeadUserFollowInfoViewWidth/2, LTMeHeadUserFollowInfoViewHeight);
    self.infoLabel.size = CGSizeMake(LTMeHeadUserFollowInfoViewWidth/2, LTMeHeadUserFollowInfoViewHeight);
    
    self.numLabel.centerY = self.bounds.size.height / 2;
    self.infoLabel.centerY = self.bounds.size.height / 2;
    
    self.numLabel.left = 0;
    self.infoLabel.left = self.numLabel.right;
}

//-(void)updateConstraints{
//    
//    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self);
//        make.right.equalTo(self.infoLabel.mas_left);
//        make.centerY.equalTo(self.mas_centerY);
//    }];
//    
//    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right);
//        make.centerY.equalTo(self.mas_centerY);
//    }];
//    [super updateConstraints];
//}

@end
