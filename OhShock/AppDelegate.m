//
//  AppDelegate.m
//  OhShock
//
//  Created by Lintao.Yu on 12/3/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "AppDelegate.h"
#import "IntroductionViewController.h"
#import "LTLogInService.h"
//leanCloud
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "LTMainTabBarController.h"
#import "UIColor+expanded.h"
#import "UIImage+Common.h"
#import "CDChatManager.h"

#define kColorTableSectionBg [UIColor colorWithHexString:@"0xe5e5e5"]
#define  kNavTitleFontSize 19

static NSString *AppID = @"AeqpkvIfdCdKWr080LveKfEl";
static NSString *AppKey = @"UwgavmLDCILH6xr6P7gXob8J";
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    /////////////////////////////////////////////////////////////
    /////////////////云服务注册////////////////////////////////////
    
    [AVOSCloud setApplicationId:AppID
                      clientKey:AppKey];
    
    /////////////////////////////////////////////////////////////
    /////////////////界面设置/////////////////////////////////////
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    /////////////////////////////////////////////////////////////
    [[CDChatManager manager] openWithClientId:[AVUser currentUser].objectId callback: ^(BOOL succeeded, NSError *error) {
        if (!error) {
            if (succeeded) {
                NSLog(@"openWithClientId 成功");
            }
        } else{
            NSLog(@"openWithClientId 失败 %@",error);
        }
    }];

    
    
    /////////////////////////////////////////////////////////////
    /////////////////业务逻辑/////////////////////////////////////
    
    
    //如果没有登陆
    if (![LTLogInService currentUser]) {
        //跳转到介绍登陆&注册
        [self setupIntroductionViewController];
    }else{
        //跳转到主业务逻辑页面
        [self setupMainViewController];
    }
    [self.window makeKeyAndVisible];
    
    [self customizeInterface];
    
    return YES;
}

#pragma mark - 页面跳转
#pragma mark 跳转到引导页面

- (void)setupIntroductionViewController{
    IntroductionViewController *intoVC = [[IntroductionViewController alloc]init];
    [self.window setRootViewController:intoVC];
}

#pragma mark 跳转到主业务逻辑页面
- (void)setupMainViewController{
    LTMainTabBarController *mainViewController = [LTMainTabBarController new];
    [self.window setRootViewController:mainViewController];
}

#pragma mark - Interface
/**
 *  @author Lintao Yu, 15-12-04 16:12:53
 *
 *  设置整个 APP 的原生控件的颜色样式之类（暂时不修改）
 */
- (void)customizeInterface {
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    //设置Nav的背景色和title色
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    NSDictionary *textAttributes = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        [navigationBarAppearance setTintColor:[UIColor whiteColor]];//返回按钮的箭头颜色
        [[UITextField appearance] setTintColor:[UIColor colorWithHexString:@"0x3bbc79"]];//设置UITextField的光标颜色
        [[UITextView appearance] setTintColor:[UIColor colorWithHexString:@"0x3bbc79"]];//设置UITextView的光标颜色
        [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:kColorTableSectionBg] forBarPosition:0 barMetrics:UIBarMetricsDefault];
        
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:kNavTitleFontSize],
                           NSForegroundColorAttributeName: [UIColor whiteColor],
                           };
    }else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:kColorTableSectionBg]];
        
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:kNavTitleFontSize],
                           UITextAttributeTextColor: [UIColor whiteColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    [navigationBarAppearance setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x28303b"]] forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}

@end
