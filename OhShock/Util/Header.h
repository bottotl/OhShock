//
//  Header.h
//  LocationPicker
//
//  Created by roroge on 15/4/9.
//  Copyright (c) 2015年 com.roroge. All rights reserved.
//

#import "UIView+RGSize.h"

#define kScreen_Height      ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width       ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame       (CGRectMake(0, 0 ,kScreen_Width,kScreen_Height))
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]


//项目中用到的通知定义，方便管理
#define RefreshNotification @"__RefreshNotification__" //刷新我的群组