//
//  ScheduleCell.h
//  Step-it-up
//
//  Created by syfll on 15/8/4.
//  Copyright © 2015年 JFT0M. All rights reserved.
//

#define JFScheduleCell @"ScheduleCell"
#import <UIKit/UIKit.h>

@class LKAlarmEvent;
@interface ScheduleCell : UITableViewCell
@property (nonatomic,strong) LKAlarmEvent *event;
@end
