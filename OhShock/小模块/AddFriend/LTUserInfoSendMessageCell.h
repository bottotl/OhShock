//
//  LTUserInfoSendMessageCell.h
//  OhShock
//
//  Created by Lintao.Yu on 15/12/15.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RACSignal;
static NSString *const LTUserInfoSendMessageCellIdentifier = @"LTUserInfoSendMessageCell";
@interface LTUserInfoSendMessageCell : UITableViewCell
-(RACSignal *)rac_signalForSendMessageControlEvents;
@end
