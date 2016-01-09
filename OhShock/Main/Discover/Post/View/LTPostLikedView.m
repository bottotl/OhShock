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

@property (nonatomic, strong) YYLabel *usersNameLabel;

@end

@implementation LTPostLikedView

-(YYLabel *)usersNameLabel{
    if (!_usersNameLabel) {
        _usersNameLabel = [YYLabel new];
        _usersNameLabel.textAlignment = NSTextAlignmentCenter;
        _usersNameLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _usersNameLabel.numberOfLines = 0;
        [self addSubview:_usersNameLabel];
        
        _usersNameLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            NSLog(@"Tap: %@",[text.string substringWithRange:range]);
        };
    }
    return _usersNameLabel;
}

-(CGSize)sizeThatFits:(CGSize)size{
    
    [self setUsersName:self.data.usersNameAttributedString];
    return self.usersNameLabel.size;
}

-(void)setUsersName:(NSAttributedString *)usersName{
    CGSize size = CGSizeMake(self.width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:usersName];
    self.usersNameLabel.attributedText = usersName;
    self.usersNameLabel.size = layout.textBoundingSize;
}


+(CGFloat)heightWithUsersName:(NSAttributedString *)usersName andWith:(CGFloat)width{
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:usersName];
    return layout.textBoundingSize.height;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

@end
