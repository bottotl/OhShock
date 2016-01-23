//
//  LTPostProfileView.m
//  OhShock
//
//  Created by Lintao.Yu on 16/1/5.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTPostProfileView.h"
#import "YYKit.h"
#import "UIView+Layout.h"
#import "UIImageView+WebCache.h"


static CGFloat const LTPostProfileViewHeight = 60.0;

@interface LTPostProfileView()


@property (nonatomic, strong) YYLabel      *nameLabel;///< 用户名


@end

@implementation LTPostProfileView{
    BOOL _trackingTouch;
}
-(instancetype)init{
    self = [self initWithFrame:CGRectZero];
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    CGRect rect= CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, LTPostProfileViewHeight);
    self = [super initWithFrame:rect];
    return self;
}


-(void)layoutSubviews{
    
    self.avatarView.size = CGSizeMake(LTPostProfileViewAvatarViewHeight, LTPostProfileViewAvatarViewHeight);
    self.avatarView.layer.cornerRadius = self.avatarView.height/2;
    self.avatarView.backgroundColor = [UIColor redColor];
    self.avatarView.left = 10;
    self.avatarView.centerY = self.height/2;

    self.nameLabel.left = self.avatarView.right + 5;
    self.nameLabel.centerY = self.avatarView.centerY;
    [super layoutSubviews];
}

#pragma mark - Property
#pragma mark View property

-(YYLabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [YYLabel new];
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(UIImageView *)avatarView{
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarView.clipsToBounds = YES;
        _avatarView.userInteractionEnabled = YES;
        [self addSubview:_avatarView];
    }
    return _avatarView;
}
-(void)setAvatarUrlString:(NSString *)avatarUrlString{
    _avatarUrlString = avatarUrlString;
    if (_avatarUrlString) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:_avatarUrlString]];
    }
}
- (RACSignal *)rac_gestureSignal{
    if (!_rac_gestureSignal) {
        UITapGestureRecognizer *tapGesture;
        tapGesture = [UITapGestureRecognizer new];
        [self.avatarView addGestureRecognizer:tapGesture];
        _rac_gestureSignal = [tapGesture rac_gestureSignal] ;
    }
    return _rac_gestureSignal;
}

#pragma mark  Data property
-(void)setName:(NSString *)name{
    _name = name;
    CGSize size = CGSizeMake(kScreenWidth - 110, 24);
    
    NSMutableAttributedString *temp = [[NSMutableAttributedString alloc]initWithString:name];
    temp.font = [UIFont systemFontOfSize:15];
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:temp];
    self.nameLabel.size = layout.textBoundingSize;
    self.nameLabel.textLayout = layout;
}

#pragma mark - 高度计算
+(CGFloat)viewHeight{
    return LTPostProfileViewHeight;
}
@end
