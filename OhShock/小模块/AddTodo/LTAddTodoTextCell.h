//
//  LTAddTodoTextCell.h
//  OhShock
//
//  Created by Lintao.Yu on 15/12/24.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RACSignal;
static NSString *const LTAddTodoTextCellIdentifier = @"LTAddTodoTextCell";
/// 输入框
@interface LTAddTodoTextCell : UITableViewCell
-(RACSignal *)rac_textChangeSignal;
@end
