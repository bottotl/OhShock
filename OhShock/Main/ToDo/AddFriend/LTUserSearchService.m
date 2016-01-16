//
//  LTUserSearchService.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/15.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTUserSearchService.h"
#import <AVOSCloud/AVOSCloud.h>
@interface LTUserSearchService()
///判断我是否关注了他
@property (nonatomic ,assign) BOOL isIFollowedHim;
///判断他是否关注了我
@property (nonatomic ,assign) BOOL isHeFollowedMe;
@end
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
- (void)getFollowRelationShipWithMe:(NSString *)userId complete:(LTFindFollowTypeResponse)completeBlock{
    
    
    __weak __typeof(self) weakSelf = self;
    __block LTFollowRelationShipType type;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT ,0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue,^{
        if ([self getIfIFollowedHim:userId]) {
            NSLog(@"我关注了他");
            weakSelf.isIFollowedHim = YES;
        }else{
            NSLog(@"我没关注他");
            weakSelf.isIFollowedHim = NO;
        }
    });
    dispatch_group_async(group ,queue ,^{
        if ([self getIfHeFollowedMe:userId]) {
            NSLog(@"他关注了我");
            weakSelf.isHeFollowedMe = YES;
        }else{
            NSLog(@"他没关注我");
            weakSelf.isHeFollowedMe = NO;
        }
    });
    
    dispatch_group_notify(group ,dispatch_get_main_queue(),^{
        if (weakSelf.isHeFollowedMe) {
            if (weakSelf.isIFollowedHim) {
                type = BOTH_FOLLOWED;
            }else{
                type = HE_FOLLOWED_ME;
            }
        }else{
            if (weakSelf.isIFollowedHim) {
                type = I_FOLLOWED_HIM;
            }else{
                type = NO_RELATIONSHIP;
            }
        }
        completeBlock(type,nil);
    });

}
- (BOOL)getIfIFollowedHim:(NSString *)userId{
    AVUser *me = [AVUser currentUser];
    AVQuery *query = [self getFollowerQuery:userId];
    [query whereKey:@"follower" equalTo:me];
    NSArray *objects = [query findObjects];
    if (objects.count > 0) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)getIfHeFollowedMe:(NSString *)userId{
    AVUser *me = [AVUser currentUser];
    AVQuery *query = [self getFolloweeQuery:userId];
    [query whereKey:@"followee" equalTo:me];
    NSArray *objects = [query findObjects];
    if (objects.count > 0) {
        return YES;
    }else{
        return NO;
    }
}
/// 获取用户粉丝列表
- (AVQuery *)getFollowerQuery:(NSString *)userID{
    
    return [AVUser followerQuery:(NSString*)userID];
}
/// 获取用户关注列表
- (AVQuery *)getFolloweeQuery:(NSString *)userID{
    
    return [AVUser followeeQuery:(NSString*)userID];
}
- (void)followUserWith:(AVUser *)user andCallback:(void(^)(BOOL succeeded, NSError *error))complectBlock{
    AVUser *me = [AVUser currentUser];
    [me follow:user.objectId andCallback:^(BOOL succeeded, NSError *error) {
        if (!error) {
            if (complectBlock) {
                if(succeeded){
                    NSLog(@"关注成功");
                }
                complectBlock(succeeded,error);
            }
        }else{
            NSLog(@"followUserWith error");
        }
        
    }];

}
- (void)unfollowUserWith:(AVUser *)user andCallback:(void(^)(BOOL succeeded, NSError *error))complectBlock{
    AVUser *me = [AVUser currentUser];
    [me unfollow:user.objectId andCallback:^(BOOL succeeded, NSError *error) {
        if (!error) {
            if (complectBlock) {
                if(succeeded){
                    NSLog(@"取消关注成功");
                }
                complectBlock(succeeded,error);
            }
        }else{
            NSLog(@"unfollowUserWith error");
        }
        
    }];
    
}

- (void)changeFollowType:(AVUser *)user andCallback:(void(^)(BOOL succeeded, NSError *error))complectBlock{
    if ([self getIfIFollowedHim:user.objectId]) {
        [self unfollowUserWith:user andCallback:complectBlock];
    }else{
        [self followUserWith:user andCallback:complectBlock];
    }
}

- (void)getFollowerNum:(AVUser *)user complete:(void(^)(NSUInteger num, NSError *error))completeBlock{
    AVQuery *query= [AVUser followerQuery:user.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (completeBlock) {
                completeBlock(objects.count,error);
            }
        }else{
            NSLog(@"getFollowerNum error");
        }
    }];
}

- (void)getFolloweeNum:(AVUser *)user complete:(void(^)(NSUInteger num, NSError *error))completeBlock{
    AVQuery *query= [AVUser followeeQuery:user.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (completeBlock) {
                completeBlock(objects.count,error);
            }
        }else{
            NSLog(@"getFollowerNum error");
        }
    }];
}
/// 获取用户头像
- (void)getAvatorImageOfUser:(AVUser *)user complete:(void(^)(UIImage *image, NSError *error))complectBlock{
    AVFile *avatar = [user objectForKey:@"avatar"];
    if (avatar) {
        [avatar getDataInBackgroundWithBlock: ^(NSData *data, NSError *error) {
            if (error == nil) {
                complectBlock([UIImage imageWithData:data],error);
            }else{
                complectBlock([UIImage imageNamed:@"zxyxwanzi_mobile"],error);;
            }
        }];
        
    }
    
}

- (void)getAvatorUrlString:(AVUser *)user complete:(void(^)(NSString *urlString, NSError *error))completeBlock{
    //AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    
    AVFile *avatorFile = [user objectForKey:@"avatar"];
    if (completeBlock) {
        if (avatorFile) {
            completeBlock(avatorFile.url,nil);
        }else{
            NSLog(@"getAvatorUrlString error");
        }
        
    }
}
@end
