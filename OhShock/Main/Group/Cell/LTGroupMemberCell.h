//
//  LTGroupMemberCell.h
//  OhShock
//
//  Created by chenlong on 16/1/6.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTGroupMemberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *msgContent;
@property (weak, nonatomic) IBOutlet UIImageView *attachImg;//状态附带的图片，可有可无
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidth;

@end
