//
//  LTGroup.h
//  OhShock
//
//  Created by chenlong on 16/1/12.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface LTGroup : AVObject<AVSubclassing>

@property (nonatomic, strong) NSString *groupName;//群名
@property (nonatomic, strong) NSString *groupStyle;//群类型
@property (nonatomic, strong) NSString *groupAddress;//群地址
@property (nonatomic, strong) NSArray *groupLabels;//群标签
@property (nonatomic, strong) NSString *groupIntroduction;//群介绍
@property (nonatomic, strong) UIImage *groupImage;//群图片
@property (nonatomic, strong) NSString *groupImageURL;//群图片地址

@end
