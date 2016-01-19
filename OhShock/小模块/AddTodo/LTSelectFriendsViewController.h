//
//  LTSelectFriendsViewController.h
//  OhShock
//
//  Created by Lintao.Yu on 15/12/30.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTAddFriendViewController.h"

@interface LTSelectFriendsViewController : LTAddFriendViewController
/// 选择的用户数组 @[AVUser,……]
@property (nonatomic, strong) NSArray *friends;
@end
