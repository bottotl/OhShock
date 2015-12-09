//
//  LTDiscoverCell.h
//  OhShock
//
//  Created by Lintao.Yu on 12/8/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *LTDiscoverCellIdentifier = @"LTDiscoverCellIdentifier";
/**
 *  @author Lintao Yu, 15-12-08 10:12:50
 *
 *  发现主页面的 Cell 
    包含一张图片、一小段文字，右边的箭头
 */
@interface LTDiscoverCell : UITableViewCell

@property (nonatomic, strong) UIImage   *showImage;
@property (nonatomic, strong) NSString  *showTitle;

- (void)setWithImage:(UIImage *)image title:(NSString *)title;

@end
