//
//  AVFile+Category.m
//  OhShock
//
//  Created by lintao.yu on 16/2/2.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "AVFile+Category.h"

@implementation AVFile (Category)

+(NSArray <AVFile *>*)fetchAll:(NSArray <AVFile *>*)files error:(NSError **)error{
    NSMutableArray *p_files = @[].mutableCopy;
    AVQuery *query = [AVFile query];
    for (AVFile *file in files) {
        AVFile *p_file = [AVFile fileWithAVObject:[query getObjectWithId:file.objectId]];
        [p_files addObject:p_file];
    }
    return p_files;
}

@end
