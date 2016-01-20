//
//  LTPostListService.m
//  OhShock
//
//  Created by Lintao.Yu on 1/15/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import "LTPostListService.h"
#import "LTModelPost.h"

@implementation LTPostListService

-(void)findModelPost:(NSInteger)fromIndex length:(NSUInteger)length block:(LTModelPostFindResponse)block{
    AVQuery *query = [LTModelPost query];
    [query orderByDescending:@"createdAt"];
    query.skip = fromIndex ;
    query.limit = length;
    [query setCachePolicy:kAVCachePolicyNetworkElseCache];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            block(nil, error);
        }else{
            block(objects, error);
        }
    }];
}
@end
