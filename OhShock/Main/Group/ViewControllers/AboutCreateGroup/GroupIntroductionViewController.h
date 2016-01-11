//
//  GroupIntroductionViewController.h
//  OhShock
//
//  Created by chenlong on 16/1/11.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupIntroductionViewController : UIViewController

@property (nonatomic, strong) void (^doneBlock) (NSString *);
@property (nonatomic, strong) NSString *introduction;//初始的群介绍文字，防止进入后重新编写

@end
