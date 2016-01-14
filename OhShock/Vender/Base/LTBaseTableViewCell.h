//
//  LTBaseTableViewCell.h
//  OhShock
//
//  Created by lintao.yu on 16/1/14.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const LTBaseTableViewCellIdentifier = @"LTBaseTableViewCell";

/**
 *  包含图片、标题、箭头文字、箭头的 TableViewCell
 */
@interface LTBaseTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImage   *showImage;
@property (nonatomic, copy) NSString  *showTitle;
@property (nonatomic, copy) NSString *accessoryText;

- (void)ConfigCell:(UIImage *)showImage andTitle:(NSString *)showTitle andaccessoryText:(NSString *)accessoryText;

+ (CGFloat)CellHeight;
@end
