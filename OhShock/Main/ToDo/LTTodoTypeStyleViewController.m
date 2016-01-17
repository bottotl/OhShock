//
//  LTTodoTypeStyleViewController.m
//  OhShock
//
//  Created by Lintao.Yu on 12/7/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTTodoTypeStyleViewController.h"

@interface LTTodoTypeStyleViewController ()

@end

@implementation LTTodoTypeStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.parentViewController.title = @"分类模式";
}

@end
