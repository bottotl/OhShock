//
//  LTTapImageView.m
//  OhShock
//
//  Created by Lintao.Yu on 12/8/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTTapImageView.h"
#import "UIImageView+WebCache.h"


@interface LTTapImageView()

@end

@implementation LTTapImageView

- (void)tap{
    if (self.tapAction) {
        self.tapAction(self);
    }
}
-(void)setTapAction:(UITapImageViewTapBlock)tapAction{
    self.tapAction = tapAction;
    if (![self gestureRecognizers]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
}

-(void)setImageWithUrl:(nullable NSURL *)imgUrl placeholderImage:(nullable UIImage *)placeholderImage tapBlock:(nullable UITapImageViewTapBlock)tapAction{
    [self sd_setImageWithURL:imgUrl placeholderImage:placeholderImage];
    [self setTapAction:tapAction];
}

@end
