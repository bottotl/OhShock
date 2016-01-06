//
//  LTGroupMemberCell.m
//  OhShock
//
//  Created by chenlong on 16/1/6.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTGroupMemberCell.h"
#import "Header.h"

@implementation LTGroupMemberCell

- (void)awakeFromNib {
    // Initialization code
//    //如果没有图片，移除imgV,添加新约束
//    [_attachImg removeFromSuperview];
//    [self.contentView addConstraint:[NSLayoutConstraint
//                              constraintWithItem:_msgContent
//                              attribute:NSLayoutAttributeRight
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:[_msgContent superview]
//                              attribute:NSLayoutAttributeRight
//                              multiplier:1
//                              constant:-10]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
