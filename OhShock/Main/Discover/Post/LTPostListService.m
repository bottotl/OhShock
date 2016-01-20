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
-(void)findPostModels:(NSInteger)fromIndex length:(NSUInteger)length block:(LTPostModelFindResponse)block{
    
//    [self findModelPost:fromIndex length:length block:^(NSArray<LTModelPost *> *posts, NSError *error) {
//        NSMutableArray *postModels = @[].mutableCopy;
//        for (LTModelPost *model in posts) {
//            LTPostModel *post = [LTPostModel new];
//            post.profileData = [LTPostProfileModel new];
//            post.profileData.name = model.pubUser.username;
//            post.profileData.
//        }
//    }];
}
@end
