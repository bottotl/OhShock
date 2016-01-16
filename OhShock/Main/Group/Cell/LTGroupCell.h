//
//  LTGroupCell.h
//  OhShock
//
//  Created by chenlong on 16/1/5.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTModelGroup.h"
@interface LTGroupCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *starSign;//星标
@property (weak, nonatomic) IBOutlet UIImageView *groupImgV;//群图片
@property (weak, nonatomic) IBOutlet UILabel *groupName;//群名字

- (void)setCellWithGroup:(LTModelGroup *)group;

@end
