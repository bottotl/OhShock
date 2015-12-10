//
//  LTDiscoverDynamicViewController.m
//  OhShock
//
//  Created by Lintao.Yu on 12/8/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTDiscoverDynamicViewController.h"

@interface LTDiscoverDynamicViewController ()

@end

@implementation LTDiscoverDynamicViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"关注动态";
}

@end
