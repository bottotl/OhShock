//
//  LTAddTodoSelectionCell.h
//  OhShock
//
//  Created by Lintao.Yu on 15/12/24.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *const LTAddTodoSelectionCellIdentifier = @"LTAddTodoSelectionCell";
@interface LTAddTodoSelectionCell : UITableViewCell
@property (nonatomic, copy) NSString *rightLabelText;
-(void)ConfigeCell:(UIImage *)image leftText:(NSString *)leftText rightText:(NSString *)rightText;
@end
