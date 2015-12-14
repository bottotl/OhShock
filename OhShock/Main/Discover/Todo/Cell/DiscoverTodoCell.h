//
//  DiscoverTodoCell.h
//  ToChat
//
//  Created by syfll on 15/8/19.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKAlarmEvent.h"

#define JF_Discover_Todo_Cell @"DiscoverTodoCellIdentifier"

@interface DiscoverTodoCell : UITableViewCell
/// 决定了cell内容
@property (nonatomic, strong) LKAlarmEvent *entity;
@end
