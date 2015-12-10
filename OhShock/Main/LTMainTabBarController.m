//
//  LTMainTabBarController.m
//  OhShock
//
//  Created by Lintao.Yu on 12/7/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTMainTabBarController.h"
#import "LTTodoViewController.h"
#import "LTGroupViewController.h"
#import "LTDiscoverViewController.h"
#import "LTMeViewController.h"
#import "UIImage+Common.h"

@interface LTMainTabBarController ()

@property (nonatomic, strong) LTTodoViewController *todoTabBarController;
@property (nonatomic, strong) LTGroupViewController *groupViewController;
@property (nonatomic, strong) LTDiscoverViewController *discoverViewController;
@property (nonatomic, strong) LTMeViewController *meViewController;

@end

@implementation LTMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //  这个是用来包含3个
    _todoTabBarController = [LTTodoViewController new];
    
    _groupViewController = [LTGroupViewController new];
    UINavigationController *groupViewNavigationController = [[UINavigationController alloc]initWithRootViewController:_groupViewController];
    
    _discoverViewController = [LTDiscoverViewController new];
    UINavigationController *discoverViewNavigationController = [[UINavigationController alloc]initWithRootViewController:_discoverViewController];
    
    _meViewController = [LTMeViewController new];
    UINavigationController *meViewNavigationController = [[UINavigationController alloc]initWithRootViewController:_meViewController];
    self.viewControllers = @[_todoTabBarController,groupViewNavigationController,discoverViewNavigationController,meViewNavigationController];
    [self setSelectedIndex:0];
    
    [self customizeTabBarForController];
}

//Set TabBarItems's image and name
- (void)customizeTabBarForController {
    UITabBarItem *todoTabBarItem;
    UITabBarItem *groupTabBarItem;
    UITabBarItem *discoverTabBarItem;
    UITabBarItem *meTabBarItem;
    
    todoTabBarItem = [[UITabBarItem alloc]initWithTitle:nil  image:[[UIImage imageNamed:@"tabbar_normal"]scaledToSize:CGSizeMake(40, 40)] selectedImage:[[UIImage imageNamed:@"tabbar_selected"]scaledToSize:CGSizeMake(40, 40)]];
    groupTabBarItem = [[UITabBarItem alloc]initWithTitle:nil  image:[[UIImage imageNamed:@"tabbar_normal"]scaledToSize:CGSizeMake(40, 40)] selectedImage:[[UIImage imageNamed:@"tabbar_selected"]scaledToSize:CGSizeMake(40, 40)]];
    discoverTabBarItem = [[UITabBarItem alloc]initWithTitle:nil  image:[[UIImage imageNamed:@"tabbar_normal"]scaledToSize:CGSizeMake(40, 40)] selectedImage:[[UIImage imageNamed:@"tabbar_selected"]scaledToSize:CGSizeMake(40, 40)]];
    meTabBarItem = [[UITabBarItem alloc]initWithTitle:nil  image:[[UIImage imageNamed:@"tabbar_normal"]scaledToSize:CGSizeMake(40, 40)] selectedImage:[[UIImage imageNamed:@"tabbar_selected"]scaledToSize:CGSizeMake(40, 40)]];
    _todoTabBarController.tabBarItem = todoTabBarItem;
    _groupViewController.tabBarItem = groupTabBarItem;
    _discoverViewController.tabBarItem = discoverTabBarItem;
    _meViewController.tabBarItem = meTabBarItem;
}


@end
