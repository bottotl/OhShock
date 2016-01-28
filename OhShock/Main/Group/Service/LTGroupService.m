//
//  LTGroupService.m
//  OhShock
//
//  Created by chenlong on 16/1/13.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTGroupService.h"
#import "Header.h"
#import "LTModelUserInfo.h"
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
                    //在userinfo中加入用户参与的群
                    AVQuery *query = [LTModelUserInfo query];
                    [query whereKey:@"user" equalTo:[AVUser currentUser]];
                    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                        NSMutableArray *array = [object objectForKey:@"groups"];
                        if (!array.count) {
                            array = [NSMutableArray array];
                        }
                        [array addObject:group];
                        [object setObject:array forKey:@"groups"];
                        [object saveInBackground];
                    }];
                    [[NSNotificationCenter defaultCenter]postNotificationName:RefreshNotification object:nil];
                    complectBlock(succeeded, error);
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
- (void)getGroupOfUser:(AVUser *)user andCallback:(void(^)(BOOL succeeded, NSError *error, NSArray *array))complectBlock{
    NSMutableArray *resultArray = [NSMutableArray array];//返回结果数组
    AVQuery *query = [LTModelUserInfo query];
    [query whereKey:@"user" equalTo:user];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        NSMutableArray *groups = [object objectForKey:@"groups"];
        for (AVObject *group in groups) {
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
                    group.groupThumbnailImgageURL = [imgData getThumbnailURLWithScaleToFit:YES width:100 height:100];
                    [resultArray addObject:group];
                }else{
                    complectBlock(NO, error, nil);
                }
                
                if (groups.count == resultArray.count) {//查询完毕
                    complectBlock(YES, error, resultArray);
                }
            }];
        }
    }];
}


/**
 *  获取群组成员
 *
 *  @param group          (LTModelGroup *)
 *  @param complectBlock Block
 */
- (void)getMembersOfGroup:(LTModelGroup *)group andCallback:(void(^)(BOOL succeeded, NSError *error, NSArray *array))complectBlock{
    AVQuery *query = [LTModelGroup query];
    [query whereKey:@"groupName" equalTo:group.groupName];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            NSMutableArray *members = [object objectForKey:@"groupMembers"];
            if (members.count) {
                complectBlock(YES, nil, members);
            }else{
                complectBlock(NO, nil, [NSArray array]);
            }
        }
    }];
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
            NSMutableArray *restultArray = [NSMutableArray array];
            for (int i = 0; i < objects.count; i++) {
                AVObject *object = objects[i];
                LTModelGroup *group = [[LTModelGroup alloc]init];
                group.groupName = [object objectForKey:@"groupName"];
                group.groupStyle = [object objectForKey:@"groupStyle"];
                group.groupAddress = [object objectForKey:@"groupAddress"];
                group.groupLabels = [object objectForKey:@"groupLabels"];
                group.groupIntroduction = [object objectForKey:@"groupIntroduction"];
                AVFile *imgData = [object objectForKey:@"groupImage"];
                group.groupImageURL = [imgData url];
                group.groupThumbnailImgageURL = [imgData getThumbnailURLWithScaleToFit:YES width:100 height:100];
                [restultArray addObject:group];
            }

            completeBlock(YES, error, restultArray);
        }else{
            completeBlock(NO, error, nil);
        }
    }];
}

/**
 *  申请加入群组
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
                        message.sendFrom = (LTModelUser *)[AVUser currentUser];
                        message.sendTo = (LTModelUser *)[object objectForKey:@"groupCreator"];
                        message.isRead = NO;
                        message.isGroup = NO;
                        message.info = nil;
                        [self addMessage:message andCallback:^(BOOL succeeded, NSError *error) {
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
 *  将用户加入群组（群主通过用户申请）
 *
 *  @param user          (AVUser *)
 *  @param group         (LTModelGroup *)
 *  @param complectBlock Block
 */
- (void)let:(AVUser *)user getInGroup:(LTModelGroup *)group andCallback:(void(^)(BOOL succeeded, NSError *error))complectBlock{
    //将群加到用户所在群数组
    AVQuery *query = [LTModelUserInfo query];
    [query whereKey:@"user" equalTo:user];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            NSMutableArray *groups = [object objectForKey:@"groups"];
            if (!groups.count) {
                groups = [NSMutableArray array];
            }
            if (![groups containsObject:group]) {//如果已经在群里，跳过，否则加入
                [groups addObject:group];
                [object setObject:groups forKey:@"groups"];
                [object saveInBackground];
            }
            //将用户加到群成员数组
            NSMutableArray *members = [group objectForKey:@"groupMembers"];
            //这个members至少有一个元素
            if (![members containsObject:user]) {
                [members addObject:user];
                [group setObject:members forKey:@"groupMembers"];
                [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        complectBlock(succeeded, error);
                    }
                }];
            }
            complectBlock(YES, error);
        }
    }];
}


/**
 *  将用户移出群组
 *
 *  @param user          (AVUser *)
 *  @param group         (LTModelGroup *)
 *  @param complectBlock Block
 */
- (void)let:(AVUser *)user getOutGroup:(LTModelGroup *)group andCallback:(void(^)(BOOL succeeded, NSError *error))complectBlock{
    //将群移出用户所在群数组
    AVQuery *query = [LTModelUserInfo query];
    [query whereKey:@"user" equalTo:user];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            NSMutableArray *groups = [object objectForKey:@"groups"];
            [groups removeObject:user];
            [object saveInBackground];
            
            //将用户移出群成员数组
            NSMutableArray *members = [group objectForKey:@"groupMembers"];
            //这个members至少有一个元素
            [members removeObject:user];
            [group setObject:members forKey:@"groupMembers"];
            [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    complectBlock(succeeded, error);
                }
            }];
            complectBlock(YES, error);
            
        }
    }];
}



/**
 *  添加消息
 *
 *  @param message       (LTModelMessage *)
 *  @param complectBlock Block
 */
- (void)addMessage:(LTModelMessage *)message andCallback:(void(^)(BOOL succeeded, NSError *error))complectBlock{
    [message setObject:message.sendFrom forKey:@"sendFrom"];
    [message setObject:message.sendTo forKey:@"sendTo"];
    [message setObject:message.content forKey:@"content"];
    [message setObject:@(message.isRead) forKey:@"isRead"];
    [message setObject:@(message.isGroup) forKey:@"isGroup"];
    [message setObject:message.info forKey:@"info"];
    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //消息保存完毕后，推送消息目标用户,目标用户接受到推送后在响应后再加到他自己的未读消息队列
            AVUser *sendToUser = (AVUser *) message.sendTo;
            AVQuery *pushQuery = [AVInstallation query];
            [pushQuery whereKey:@"Token" equalTo:[sendToUser objectForKey:@"objectId"]];
            NSLog(@"unReadMessage ID is ::%@", [message objectForKey:@"objectId"]);
            NSDictionary *data = @{
                                   @"alert": [NSString stringWithFormat:@"%@%@", [[AVUser currentUser] objectForKey:@"username"], message.content],
                                   @"badge":@"Increment",
                                   @"unReadMessageId":[message objectForKey:@"objectId"],
                                   @"type":@"0"//消息类型，这里先随便设置，0是申请入群
                                   };
            AVPush *push = [[AVPush alloc]init];
            [push setQuery:pushQuery];
            [push setData:data];
            [push sendPushInBackground];
        }else{
            complectBlock(NO, error);
        }
    }];
}

///**
// *  添加未读消息到队列（该队列在user表中是一个字段，保存为消息ID数组）
// *
// *  @param message       (LTModelMessage *)
// *  @param complectBlock Block
// */
//- (void)addUnreadMessage:(NSString *)messageID andCallback:(void(^)(BOOL succeeded, NSError *error))complectBlock{
//    NSMutableArray *messageArray = [[AVUser currentUser] objectForKey:@"unReadMessages"];
//    if (messageArray == nil) {
//        messageArray = [NSMutableArray array];
//    }
//    [messageArray addObject:messageID];
//    [[AVUser currentUser] setObject:messageArray forKey:@"unReadMessages"];
//    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        complectBlock(succeeded, error);
//    }];
//}


/**
 *  获取未读消息
 *
 *  @param completeBlock 回调 Block
 */
- (void)getUnReadMessagesWithcomplete:(void(^)(BOOL succeeded, NSError *error, NSArray *array))completeBlock{
    AVQuery *query = [LTModelMessage query];
    query.cachePolicy = kAVCachePolicyCacheThenNetwork;
    [query whereKey:@"sendTo" equalTo:[AVUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            completeBlock(YES, nil, objects);
        }else{
            completeBlock(NO, error, [NSArray array]);
        }
    }];
}

@end
