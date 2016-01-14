//
//  LTUploadTextAndPhotosCell.h
//  OhShock
//
//  Created by lintao.yu on 16/1/14.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTUploadTextAndPhotosView.h"

static NSString *const LTUploadTextAndPhotosCellIdentifier = @"LTUploadTextAndPhotosCell";
@interface LTUploadTextAndPhotosCell : UITableViewCell

-(void)configCell:(NSArray *)photos;

+(CGFloat)cellHeight:(NSArray *)photos;

@end
