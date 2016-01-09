//
//  PickView.m
//  zsp
//
//  Created by chenLong on 15/6/3.
//  Copyright (c) 2015年 chenLong. All rights reserved.
//

#import "PickView.h"

@implementation PickView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//
//-(void)awakeFromNib{
//    [[NSBundle mainBundle] loadNibNamed:@"PickView" owner:self options:nil];
//    [self addSubview: self.myPicker];
//}
- (IBAction)clickCancel:(id)sender {
    [self.delegate cancel];
}
- (IBAction)clickEnsure:(id)sender {
    [self.delegate ensure];
}

@end
