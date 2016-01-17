//
//  LTModelUser.h
//  OhShock
//
//  Created by Lintao.Yu on 1/10/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface LTModelUser : AVUser <AVSubclassing>

@property (nonatomic, strong) AVFile *avatar;

@end
