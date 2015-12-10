//
//  LTTodoViewController.h
//  OhShock
//
//  Created by Lintao.Yu on 12/7/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTTodoViewController : UIViewController

/// 子控制器
@property (nonatomic, strong) NSArray *viewControllers;
/// 选中第几个页面
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) UIViewController *selectedViewController;
@end
