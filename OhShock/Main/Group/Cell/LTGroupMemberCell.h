//
//  LTGroupMemberCell.h
//  OhShock
//
//  Created by chenlong on 16/1/28.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface LTGroupMemberCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarImg;//头像
@property (nonatomic, strong) UILabel *nameLabel;//用户名
@property (nonatomic, strong) UILabel *contentLabel;//动态内容
@property (nonatomic, strong) UIImageView *contentImg;//动态图片，可有可无

- (void)setCellWith:(AVObject *)obj;

@end
