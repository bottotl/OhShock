//
//  LTPostLikedView.m
//  OhShock
//
//  Created by Lintao.Yu on 1/9/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import "LTPostLikedView.h"
#import "YYControl.h"

@interface LTPostLikedView ()

@property (nonatomic, strong) YYLabel *usersNameLabel;///< 显示有哪些用户点赞了

@end

@implementation LTPostLikedView

#pragma mark - property
-(YYLabel *)usersNameLabel{
    if (!_usersNameLabel) {
        _usersNameLabel = [YYLabel new];
        _usersNameLabel.textAlignment = NSTextAlignmentCenter;
        _usersNameLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _usersNameLabel.numberOfLines = 0;
        [self addSubview:_usersNameLabel];
//        // 设置点击响应事件
//        _usersNameLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
//            NSLog(@"Tap: %@",[text.string substringWithRange:range]);
//        };
    }
    return _usersNameLabel;
}

#pragma mark - sizeToFit
-(CGSize)sizeThatFits:(CGSize)size{
    CGSize tempSize = CGSizeMake(size.width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:tempSize text:self.usersName];
    self.usersNameLabel.size = layout.textBoundingSize;
    self.usersNameLabel.textLayout = layout;
    return self.usersNameLabel.size;
}

#pragma mark - 计算高度
+(CGFloat)heightWithUsersName:(NSAttributedString *)usersName andWith:(CGFloat)width{
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:usersName];
    return layout.textBoundingSize.height;
}

@end
