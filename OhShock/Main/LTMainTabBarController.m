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

#pragma mark - 定制 TabBarItems
/**
 *  @author Lintao Yu, 15-12-11 13:12:29
 *
 *  Set TabBarItems's image and name
 *  定制 TabBarItems's
 *  setTitlePositionAdjustment 用来隐藏标题
 */
- (void)customizeTabBarForController {
    UIImage *todoImage = [[[UIImage imageNamed:@"tabbar_normal"]scaledToSize:CGSizeMake(40, 40)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *todoImageSelected = [[[UIImage imageNamed:@"tabbar_selected"]scaledToSize:CGSizeMake(40, 40)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *groupImage = [[[UIImage imageNamed:@"tabbar_normal"]scaledToSize:CGSizeMake(40, 40)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *groupImageSelected = [[[UIImage imageNamed:@"tabbar_selected"]scaledToSize:CGSizeMake(40, 40)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *discoverImage = [[[UIImage imageNamed:@"tabbar_normal"]scaledToSize:CGSizeMake(40, 40)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *discoverImageSelected = [[[UIImage imageNamed:@"tabbar_selected"]scaledToSize:CGSizeMake(40, 40)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *meImage = [[[UIImage imageNamed:@"tabbar_normal"]scaledToSize:CGSizeMake(40, 40)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *meImageSelected = [[[UIImage imageNamed:@"tabbar_selected"]scaledToSize:CGSizeMake(40, 40)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UITabBarItem *todoTabBarItem = [[UITabBarItem alloc]initWithTitle:nil  image:todoImage selectedImage:todoImageSelected];
    [todoTabBarItem setTitlePositionAdjustment:UIOffsetMake(0, 15)];
    
    UITabBarItem *groupTabBarItem = [[UITabBarItem alloc]initWithTitle:nil  image:groupImage selectedImage:groupImageSelected];
    [groupTabBarItem setTitlePositionAdjustment:UIOffsetMake(0, 15)];
    
    UITabBarItem *discoverTabBarItem = [[UITabBarItem alloc]initWithTitle:nil  image:discoverImage selectedImage:discoverImageSelected];
    [discoverTabBarItem setTitlePositionAdjustment:UIOffsetMake(0, 15)];
    
    UITabBarItem *meTabBarItem = [[UITabBarItem alloc]initWithTitle:nil  image:meImage selectedImage:meImageSelected];
    [meTabBarItem setTitlePositionAdjustment:UIOffsetMake(0, 15)];
    
    _todoTabBarController.tabBarItem = todoTabBarItem;
    _groupViewController.tabBarItem = groupTabBarItem;
    _discoverViewController.tabBarItem = discoverTabBarItem;
    _meViewController.tabBarItem = meTabBarItem;
}


@end
