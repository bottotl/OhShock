//
//  JoinGroupCell.m
//  OhShock
//
//  Created by chenlong on 16/1/15.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "JoinGroupCell.h"
#import "Header.h"

@implementation JoinGroupCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatar = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        _avatar.layer.masksToBounds = YES;
        _avatar.layer.cornerRadius = 20;
        [self.contentView addSubview:_avatar];
        
        _userName = [[UILabel alloc]initWithFrame:CGRectMake(58, 9, kScreen_Width - 78, 21)];
        _userName.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_userName];
        
        _message = [[UILabel alloc]initWithFrame:CGRectMake(58, 35, kScreen_Width - 78, 16)];
        _message.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_message];
    }
    return self;
}

@end
