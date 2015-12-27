//
//  LTMeLogOutCell.h
//  OhShock
//
//  Created by Lintao.Yu on 15/12/14.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RACSignal;
static NSString *const LTMeLogOutCellIdentifier = @"LTMeLogOutCell";
@interface LTMeLogOutCell : UITableViewCell
-(RACSignal *)rac_signalForLogOutControlEvents;
@end
