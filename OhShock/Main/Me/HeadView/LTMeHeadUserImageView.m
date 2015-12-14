//
//  LTMeHeadUserImageView.m
//  OhShock
//
//  Created by Lintao.Yu on 12/8/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTMeHeadUserImageView.h"
#import "ReactiveCocoa.h"

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
        self.clipsToBounds = YES;
        self.layer.cornerRadius = rect.size.height / 2;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [UITapGestureRecognizer new];
        [self addGestureRecognizer:tapGesture];
        [[tapGesture rac_gestureSignal]subscribeNext:^(id x) {
            NSLog(@"sda");
        }];
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
