//
//  SetGroupLabelsViewController.h
//  OhShock
//
//  Created by chenlong on 16/1/11.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetGroupLabelsViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) void (^doneBlock) (NSMutableArray *);

@end
