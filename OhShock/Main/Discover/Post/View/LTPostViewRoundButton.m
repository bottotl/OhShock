//
//  LTPostViewRoundButton.m
//  OhShock
//
//  Created by Lintao.Yu on 1/9/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import "LTPostViewRoundButton.h"
#import "UIColor+expanded.h"

@interface LTPostViewRoundButton ()

@end

@implementation LTPostViewRoundButton

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 7;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithHexString:@"#2bd192"].CGColor;
        [self setTitleColor:[UIColor colorWithHexString:@"#2bd192"] forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

@end
