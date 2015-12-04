//
//  AppDelegate.m
//  OhShock
//
//  Created by Lintao.Yu on 12/3/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "AppDelegate.h"
#import "IntroductionViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    //第一次打开应用
    if (true) {
        //跳转到引导界面
        [self setupIntroductionViewController];
    }else{
        
    }
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - 页面跳转
#pragma mark 跳转到引导页面

- (void)setupIntroductionViewController{
    IntroductionViewController *intoVC = [[IntroductionViewController alloc]init];
    [self.window setRootViewController:intoVC];
}


#pragma mark - Interface
- (void)customizeInterface {
//    //设置Nav的背景色和title色
//    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
//    NSDictionary *textAttributes = nil;
//    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
//        [navigationBarAppearance setTintColor:[UIColor whiteColor]];//返回按钮的箭头颜色
//        [[UITextField appearance] setTintColor:[UIColor colorWithHexString:@"0x3bbc79"]];//设置UITextField的光标颜色
//        [[UITextView appearance] setTintColor:[UIColor colorWithHexString:@"0x3bbc79"]];//设置UITextView的光标颜色
//        [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:kColorTableSectionBg] forBarPosition:0 barMetrics:UIBarMetricsDefault];
//        
//        textAttributes = @{
//                           NSFontAttributeName: [UIFont boldSystemFontOfSize:kNavTitleFontSize],
//                           NSForegroundColorAttributeName: [UIColor whiteColor],
//                           };
//    } else {
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
//        [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:kColorTableSectionBg]];
//        
//        textAttributes = @{
//                           UITextAttributeFont: [UIFont boldSystemFontOfSize:kNavTitleFontSize],
//                           UITextAttributeTextColor: [UIColor whiteColor],
//                           UITextAttributeTextShadowColor: [UIColor clearColor],
//                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
//                           };
//#endif
//    }
//    [navigationBarAppearance setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x28303b"]] forBarMetrics:UIBarMetricsDefault];
//    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}

@end
