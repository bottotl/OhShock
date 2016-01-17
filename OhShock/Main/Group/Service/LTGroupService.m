//
//  LTGroupService.m
//  OhShock
//
//  Created by chenlong on 16/1/13.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTGroupService.h"
#import "Header.h"

@implementation LTGroupService

/**
 *  创建群组
 *
 *  @param group          (LTModelGroup *)
 *  @param complectBlock Block
 */
- (void)createGroupWith:(LTModelGroup *)group andCallback:(void(^)(BOOL succeeded, NSError *error))complectBlock{
    [group setObject:[AVUser currentUser] forKey:@"groupCreator"];
    [group addUniqueObjectsFromArray:[NSArray arrayWithObjects:[AVUser currentUser], nil] forKey:@"groupMembers"];
    
    [group setObject:group.groupName forKey:@"groupName"];
    [group setObject:group.groupStyle forKey:@"groupStyle"];
    [group setObject:group.groupAddress forKey:@"groupAddress"];
    [group addUniqueObjectsFromArray:group.groupLabels forKey:@"groupLabels"];
    [group setObject:group.groupIntroduction forKey:@"groupIntroduction"];
    NSData *imageData = UIImagePNGRepresentation(group.groupImage);
    AVFile *imageFile = [AVFile fileWithName:[NSString stringWithFormat:@"%@GroupImage", group.groupName] data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [group setObject:imageFile forKey:@"groupImage"];
            [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSMutableArray *groupArray = [[AVUser currentUser] objectForKey:@"groupArray"];
                    if (groupArray == nil) {
                        groupArray = [NSMutableArray array];
                    }
                    [groupArray addObject:group];
                    [[AVUser currentUser] setObject:groupArray forKey:@"groupArray"];
                    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:RefreshNotification object:nil];
                            complectBlock(succeeded, error);
                        }
                    }];
                }else{
                    complectBlock(succeeded, error);
                }
            }];
        }
    }];
}

/**
 *  获取用户群组列表
 *
 *  @param user          (AVUser *)
 *  @param complectBlock Block
 */
- (void)getGroupOfUser:(AVUser *)group andCallback:(void(^)(BOOL succeeded, NSError *error, NSArray *array))complectBlock{
    NSMutableArray *resultArray = [NSMutableArray array];//返回结果数组
    NSArray *groupIdArray = [[AVUser currentUser] objectForKey:@"groupArray"];
    for (AVObject *group in groupIdArray) {
        AVQuery *query = [AVQuery queryWithClassName:@"LTModelGroup"];
        [query whereKey:@"objectId" equalTo:group.objectId];
        [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            if (object) {
                LTModelGroup *group = [[LTModelGroup alloc]init];
                group.groupName = [object objectForKey:@"groupName"];
                group.groupStyle = [object objectForKey:@"groupStyle"];
                group.groupAddress = [object objectForKey:@"groupAddress"];
                group.groupLabels = [object objectForKey:@"groupLabels"];
                group.groupIntroduction = [object objectForKey:@"groupIntroduction"];
                AVFile *imgData = [object objectForKey:@"groupImage"];
                group.groupImageURL = [imgData url];
                [resultArray addObject:group];
            }else{
                complectBlock(NO, error, nil);
            }

            if (groupIdArray.count == resultArray.count) {//查询完毕
                complectBlock(YES, error, resultArray);
            }
        }];
    }
}

/**
 *  按关键字搜索群组
 *
 *  @param partName      搜索关键字
 *  @param completeBlock 回调 Block
 */
- (void)findGroupByPartname:(NSString *)partName complete:(void(^)(BOOL succeeded, NSError *error, NSArray *array))completeBlock{
    AVQuery *query = [AVQuery queryWithClassName:@"LTModelGroup"];
    [query whereKey:@"groupName" containsString:partName];
    [query orderByAscending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            completeBlock(YES, error, objects);
        }else{
            completeBlock(NO, error, nil);
        }
    }];
}

/**
 *  加入群组
 *
 *  @param group          (LTModelGroup *)
 *  @param complectBlock Block
 */
- (void)joinGroupWith:(LTModelGroup *)group andCallback:(void(^)(BOOL succeeded, NSError *error))complectBlock{
    AVQuery *query = [AVQuery queryWithClassName:@"LTModelGroup"];
    [query whereKey:@"groupName" equalTo:group.groupName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count) {
                AVObject *object = objects[0];
                NSMutableArray *groupArray = [object objectForKey:@"wantJoins"];//获取想要加入成员数组
                if (groupArray == nil) {
                    groupArray = [NSMutableArray array];
                }
                [groupArray addObject:[AVUser currentUser]];
                [object setObject:groupArray forKey:@"wantJoins"];
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        //向群主添加未读消息
                        LTModelMessage *message = [[LTModelMessage alloc]init];
                        message.content = [NSString stringWithFormat:@"申请加入 %@", [object objectForKey:@"groupName"]];
                        message.sendTo = (LTModelUser *)[object objectForKey:@"groupCreator"];
                        message.isRead = NO;
                        message.isGroup = NO;
                        message.info = nil;
                        [self addUnReadMessafe:message andCallback:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                complectBlock(YES, error);
                            }else{
                                complectBlock(NO, error);
                            }
                        }];
                    }else{
                        complectBlock(NO, error);
                    }
                }];
            }
        }else{
            complectBlock(NO, error);
        }
    }];
}


/**
 *  为用户添加未读消息
 *
 *  @param message       (LTModelMessage *)
 *  @param complectBlock Block
 */
- (void)addUnReadMessafe:(LTModelMessage *)message andCallback:(void(^)(BOOL succeeded, NSError *error))complectBlock{
    [message setObject:message.sendFrom forKey:@"sendFrom"];
    [message setObject:message.sendTo forKey:@"sendTo"];
    [message setObject:message.content forKey:@"content"];
    [message setObject:@(message.isRead) forKey:@"isRead"];
    [message setObject:@(message.isGroup) forKey:@"isGroup"];
    [message setObject:message.info forKey:@"info"];
    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //消息保存完毕后，推送消息目标用户
            AVUser *sendToUser = (AVUser *) message.sendTo;
            NSLog(@"user name of sendTo :: %@", [sendToUser objectForKey:@"objectId"]);
            AVQuery *pushQuery = [AVInstallation query];
            [pushQuery whereKey:@"Token" equalTo:[sendToUser objectForKey:@"objectId"]];
            AVPush *push = [[AVPush alloc]init];
            [push setQuery:pushQuery];
            [push setMessage:[NSString stringWithFormat:@"%@%@", [[AVUser currentUser] objectForKey:@"username"], message.content]];
            [push sendPushInBackground];
        }else{
            complectBlock(NO, error);
        }
    }];
}

@end
