//
//  AVFile+Category.h
//  OhShock
//
//  Created by lintao.yu on 16/2/2.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface AVFile (Category)
+(NSArray <AVFile *>*)fetchAll:(NSArray <AVFile *>*)files error:(NSError **)error;
@end
