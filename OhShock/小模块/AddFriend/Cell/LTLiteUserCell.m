//
//  LTLiteUserCell.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/15.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTLiteUserCell.h"

@implementation LTLiteUserCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:false animated:animated];
}
-(void)setUserName:(NSString *)userName{
    [self.textLabel setText:userName];
}

@end
