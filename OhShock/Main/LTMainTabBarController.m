//
//  LTMainTabBarController.m
//  OhShock
//
//  Created by Lintao.Yu on 12/7/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTMainTabBarController.h"
#import "LTTodoTabBarController.h"
#import "LTGroupViewController.h"
#import "LTDiscoverViewController.h"
#import "LTMeViewController.h"
#import "RDVTabBarItem.h"

@interface LTMainTabBarController ()

//@property (nonatomic, strong)

@end

@implementation LTMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //  这个是用来包含3个
    LTTodoTabBarController *todoTabBarController = [LTTodoTabBarController new];
    LTGroupViewController *groupViewController = [LTGroupViewController new];
    LTDiscoverViewController *discoverViewController = [LTDiscoverViewController new];
    LTMeViewController *meViewController = [LTMeViewController new];
    self.viewControllers = @[todoTabBarController,groupViewController,discoverViewController,meViewController];
    [self setSelectedIndex:0];
    
    [self customizeTabBarForController];
    
#pragma mark for debug
    groupViewController.view.backgroundColor = [UIColor blackColor];
    discoverViewController.view.backgroundColor = [UIColor grayColor];
    meViewController.view.backgroundColor = [UIColor yellowColor];
}

//Set TabBarItems's image and name
- (void)customizeTabBarForController {
//    NSArray *tabBarItemSelectedImages = @[@"tabbar_normal", @"tabbar_normal", @"tabbar_normal", @"tabbar_normal"];
//    NSArray *tabBarItemImages = @[@"tabbar_selected", @"tabbar_selected", @"tabbar_selected", @"tabbar_selected"];
//    NSArray *tabBarItemTitles = @[@"日程",@"群组",@"发现",@"我"];
    
    UIImage *finishedImage = nil;
    UIImage *unfinishedImage = nil;
    
    RDVTabBar *tabBar = self.tabBar;
    
    [tabBar setFrame:CGRectMake(CGRectGetMinX(tabBar.frame), CGRectGetMinY(tabBar.frame), CGRectGetWidth(tabBar.frame), 63)];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [tabBar items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:@"tabbar_selected"];
        UIImage *unselectedimage = [UIImage imageNamed:@"tabbar_normal"];
        [item setFinishedSelectedImage:[selectedimage scaledToSize:CGSizeMake(40, 40)]
           withFinishedUnselectedImage:[unselectedimage scaledToSize:CGSizeMake(40, 40)]];
        
        index++;
    }
}


@end
