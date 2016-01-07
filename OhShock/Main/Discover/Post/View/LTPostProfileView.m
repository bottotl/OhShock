//
//  LTPostProfileView.m
//  OhShock
//
//  Created by Lintao.Yu on 16/1/5.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTPostProfileView.h"
#import "SDWebImage/SDWebImage/UIImageView+WebCache.h"
#import "YYKit.h"
#import "UIView+Layout.h"

static CGFloat const LTPostProfileViewHeight = 56.0;

@interface LTPostProfileView()
@property (nonatomic, strong) UIImageView  *avatarView;///< 头像
@property (nonatomic, strong) UIImageView  *avatarBadgeView;///< 徽章
@property (nonatomic, strong) YYLabel      *nameLabel;///< 用户名
@property (nonatomic, strong) YYLabel      *sourceLabel;///< 设备
@property (nonatomic, strong) UIImageView  *backgroundImageView;///< 背景图片
@property (nonatomic, strong) UIButton     *arrowButton;///< 阅读数量按钮
@property (nonatomic, strong) UIButton     *followButton;///< 关注按钮
@end

@implementation LTPostProfileView{
    BOOL _trackingTouch;
}
-(instancetype)init{
    self = [self initWithFrame:CGRectZero];
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, LTPostProfileViewHeight)];
    if (self) {
        _avatarView = [UIImageView new];
        _avatarView.clipsToBounds = YES;
        [self addSubview:_avatarView];
        
        _avatarBadgeView = [UIImageView new];
        [self addSubview:_avatarBadgeView];
        
        _nameLabel = [YYLabel new];
//        _nameLabel.displaysAsynchronously = YES;
//        _nameLabel.ignoreCommonProperties = YES;
//        _nameLabel.fadeOnAsynchronouslyDisplay = NO;
//        _nameLabel.fadeOnHighlight = NO;
//        _nameLabel.lineBreakMode = NSLineBreakByClipping;
//        _nameLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        [self addSubview:_nameLabel];
        
        _sourceLabel = [YYLabel new];
//        _sourceLabel.displaysAsynchronously = YES;
//        _sourceLabel.ignoreCommonProperties = YES;
//        _sourceLabel.fadeOnAsynchronouslyDisplay = NO;
//        _sourceLabel.fadeOnHighlight = NO;
//        _sourceLabel.lineBreakMode = NSLineBreakByClipping;
//        _sourceLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;

        [self addSubview:_sourceLabel];
        
        _backgroundImageView = [UIImageView new];
        [self addSubview:_backgroundImageView];
        
        _arrowButton = [UIButton new];
        [self addSubview:_arrowButton];
        
        _followButton = [UIButton new];
        [self addSubview:_followButton];
    }
    return self;
}
-(void)setAvatatImageWithUrlString:(NSString *)avatarUrlString{
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:avatarUrlString]];
}
-(void)setName:(NSString *)name{
    CGSize size = CGSizeMake(kScreenWidth - 110, 24);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:[[NSAttributedString alloc]initWithString:name]];
    _nameLabel.size = layout.textBoundingSize;
    _nameLabel.textLayout = layout;
    
}
-(void)layoutSubviews{
    _avatarView.size = CGSizeMake(50, 50);
    _avatarView.layer.cornerRadius = _avatarView.height/2;
    _avatarView.backgroundColor = [UIColor redColor];
    _avatarView.left = 10;
    _avatarView.centerY = self.height/2;

    _nameLabel.left = _avatarView.right + 5;
    _nameLabel.bottom = _avatarView.centerY;
    [super layoutSubviews];
}

+(CGFloat)viewHeight{
    return LTPostProfileViewHeight;
}
@end
