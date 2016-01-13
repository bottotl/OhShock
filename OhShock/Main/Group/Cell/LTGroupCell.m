//
//  LTGroupCell.m
//  OhShock
//
//  Created by chenlong on 16/1/5.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTGroupCell.h"
#import "UIImageView+WebCache.h"

@implementation LTGroupCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithGroup:(LTGroup *)group{
    _groupName.text = group.groupName;
    [_groupImgV setImageWithURL:[NSURL URLWithString:group.groupImageURL]];
}

@end
