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
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "LTModels.h"

#import "LTGroupService.h"
#import "LTGroupMessageViewController.h"
#import "CDChatManager.h"
#import "CDUserFactory.h"


#define kColorTableSectionBg [UIColor colorWithHexString:@"0xe5e5e5"]
#define  kNavTitleFontSize 19
#define GAODE_APPKEY @"cbf7020906739e6c33110f18bc6f261e" //高德地图key


static NSString *const AppID = @"AeqpkvIfdCdKWr080LveKfEl";
static NSString *const AppKey = @"UwgavmLDCILH6xr6P7gXob8J";
@interface AppDelegate ()

@end

@implementation AppDelegate{
    LTMainTabBarController *mainViewController;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //云服务注册
    [self leanChatInit];
    
    /////////////////////////////////////////////////////////////
    /////////////////界面设置/////////////////////////////////////
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    

    /// 注册推送
    [self registerPush];
    
    
    //注册高德地图AppKey
    [AMapLocationServices sharedServices].apiKey=GAODE_APPKEY;
    [AMapSearchServices sharedServices].apiKey=GAODE_APPKEY;
    
    

    
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

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //清badge
    long num = application.applicationIconBadgeNumber;
    if(num!=0){
        AVInstallation *currentInstallation = [AVInstallation currentInstallation];
        [currentInstallation setBadge:0];
        [currentInstallation saveEventually];
        application.applicationIconBadgeNumber=0;
    }
    [application cancelAllLocalNotifications];
}

#pragma mark - LeanChat 相关类初始化
- (void)leanChatInit{
    [LTModelUser registerSubclass];
    [LTModelPost registerSubclass];
    [LTModelPostComment registerSubclass];
    
    [AVOSCloud setApplicationId:AppID
                      clientKey:AppKey];
    [CDChatManager manager].userDelegate = [[CDUserFactory alloc] init];
}

#pragma mark - 页面跳转
#pragma mark 跳转到引导页面

- (void)setupIntroductionViewController{
    IntroductionViewController *intoVC = [[IntroductionViewController alloc]init];
    [self.window setRootViewController:intoVC];
}

#pragma mark 跳转到主业务逻辑页面
- (void)setupMainViewController{
    mainViewController = [LTMainTabBarController new];
    [self.window setRootViewController:mainViewController];
}


#pragma mark - Interface
/**
 *  @author Lintao Yu, 15-12-04 16:12:53
 *
 *  设置整个 APP 的原生控件的颜色样式之类（暂时不修改）
 */
- (void)customizeInterface {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
#pragma clang diagnostic push
#pragma clang diagnostic pop
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
#pragma mark - 注册推送
- (void)registerPush{
    //设置生产坏境还是开发环境
    [AVPush setProductionMode:NO];
    
    UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
    UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                 categories:[NSSet setWithObject:categorys]];
    [[UIApplication sharedApplication] registerUserNotificationSettings:userSettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
//    [AVPush setProductionMode:YES];
}

//接收到推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))handler {
    NSLog(@"didReceiveRemoteNotification");

    BOOL isActive = [UIApplication sharedApplication].applicationState == UIApplicationStateActive;//这个要事先保存起来，发现如果由通知打开app，在回调返回后应用状态会从UIApplicationStateInactive变成UIApplicationStateActive
    if ([userInfo[@"type"] isEqualToString:@"0"]) {//添加未读消息
        if (!isActive) {//保存未读消息成功后，判断应用是否在后台，在后台收到未读消息通知调到未读消息界面
            mainViewController.selectedIndex = 1;
            LTGroupMessageViewController *controller = [[LTGroupMessageViewController alloc]init];
            [mainViewController.selectedViewController pushViewController:controller animated:YES];
        }
    }
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册失败，无法获取设备 ID, 具体错误: %@", error);
}


@end
