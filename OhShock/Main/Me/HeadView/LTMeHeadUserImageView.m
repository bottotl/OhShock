//
//  LTMeHeadUserImageView.m
//  OhShock
//
//  Created by Lintao.Yu on 12/8/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTMeHeadUserImageView.h"


@implementation LTMeHeadUserImageView

#pragma mark - init
- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect rect = CGRectMake(0, 0, LTMeHeadUserImageViewHeigthAndWidth, LTMeHeadUserImageViewHeigthAndWidth);
    self = [super initWithFrame:rect];
    if (self) {
        
    }
    return self;
}

#pragma mark - property

- (void)setAvatorUrlString:(NSString *)avatorUrlString{
    [self setImageWithUrl:[NSURL URLWithString:avatorUrlString] placeholderImage:nil tapBlock:self.tapAction];
}
-(void)setFrame:(CGRect)frame{
    frame = CGRectMake(frame.origin.x, frame.origin.y, LTMeHeadUserImageViewHeigthAndWidth, LTMeHeadUserImageViewHeigthAndWidth);
    [super setFrame:frame];
}

@end
