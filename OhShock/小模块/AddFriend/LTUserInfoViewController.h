//
//  LTUserInfoViewController.h
//  OhShock
//
//  Created by Lintao.Yu on 15/12/15.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVUser;
/**
 *  @author Lintao Yu, 15-12-18 17:12:23
 *
 *  用户信息展示页面
 */
@interface LTUserInfoViewController : UITableViewController

@property (nonatomic, strong) AVUser *user;

- (instancetype)initWithAVUser:(AVUser *)user;
@end
