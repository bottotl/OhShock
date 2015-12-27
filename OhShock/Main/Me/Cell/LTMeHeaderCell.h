//
//  LTMeHeaderCell.h
//  OhShock
//
//  Created by Lintao.Yu on 15/12/22.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *const LTMeHeaderCellIdentitier = @"LTMeHeaderCell";
static CGFloat avatarHeight = 44 ;
static CGFloat avatarWidth = 44;
/**
 *  带一张头像的 Cell
 */
@interface LTMeHeaderCell : UITableViewCell
@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, copy) NSString *avatarUrl;
@end
