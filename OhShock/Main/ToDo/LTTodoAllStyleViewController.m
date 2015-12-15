//
//  LTTodoAllStyleViewController.m
//  OhShock
//
//  Created by Lintao.Yu on 12/7/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTTodoAllStyleViewController.h"

@interface LTTodoAllStyleViewController ()

@end

@implementation LTTodoAllStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    self.parentViewController.title = @"所有模式";
}
@end
