//
//  LTUserSearchService.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/15.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTUserSearchService.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation LTUserSearchService
- (void)findUsersByPartname:(NSString *)partName complete:(LTFindUsersResponse)completeBlock{
    AVQuery *q = [AVUser query];
    //[q setCachePolicy:kAVCachePolicyNetworkElseCache];
    [q whereKey:@"username" containsString:partName];
    AVUser *curUser = [AVUser currentUser];
    [q whereKey:@"objectId" notEqualTo:curUser.objectId];
    [q orderByDescending:@"updatedAt"];
    [q findObjectsInBackgroundWithBlock:completeBlock];

}
@end
