//
//  LTPostCommentCell.h
//  OhShock
//
//  Created by Lintao.Yu on 1/10/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const LTPostCommentCellIdentifier = @"LTPostCommentCell";

@interface LTPostCommentCell : UITableViewCell

-(void)configCellWithAttributedString:(NSAttributedString *)string;

+(CGFloat)heightWithAttributedString:(NSAttributedString *)string andWidth:(CGFloat)width;

@end
