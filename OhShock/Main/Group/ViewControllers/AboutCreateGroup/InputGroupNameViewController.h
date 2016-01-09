//
//  InputGroupNameViewController.h
//  OhShock
//
//  Created by chenlong on 16/1/9.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputGroupNameViewController : UIViewController

@property (nonatomic, strong) void (^doneBlock)(NSString *);

@end
