//
//  JoinGroupCell.h
//  OhShock
//
//  Created by chenlong on 16/1/15.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//有人要加入你创建的群组时 消息界面cell

#import <UIKit/UIKit.h>

@interface JoinGroupCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatar;//头像
@property (nonatomic, strong) UILabel *userName;//用户名
@property (nonatomic, strong) UILabel *message;//提示消息


@end
