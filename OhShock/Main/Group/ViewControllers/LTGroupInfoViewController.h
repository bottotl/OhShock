//
//  LTGroupInfoViewController.h
//  OhShock
//
//  Created by chenlong on 16/1/6.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTGroup.h"

typedef NS_ENUM(NSUInteger, CLGroupMemberType){
    CLGroupMemberLeader = 0,//群组
    CLGroupMemberManager,//管理员
    CLGroupDefault,//普通群员
    CLGroupStranger//还未入群
};

@interface LTGroupInfoViewController : UIViewController

@property (nonatomic, strong) NSString *groupName;//群名字，用作导航栏标题
@property (nonatomic, assign) CLGroupMemberType memberType;//群员类型
@property (nonatomic, strong) LTGroup *group;//群信息

@end
