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
                                   @"type":@"0"//消息类型，这里先随便设置，0是未读消息到达
                                   
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

/**
 *  添加未读消息到队列（该队列在user表中是一个字段，保存为消息ID数组）
 *
 *  @param message       (LTModelMessage *)
 *  @param complectBlock Block
 */
- (void)addUnreadMessage:(NSString *)messageID andCallback:(void(^)(BOOL succeeded, NSError *error))complectBlock{
    NSMutableArray *messageArray = [[AVUser currentUser] objectForKey:@"unReadMessages"];
    if (messageArray == nil) {
        messageArray = [NSMutableArray array];
    }
    [messageArray addObject:messageID];
    [[AVUser currentUser] setObject:messageArray forKey:@"unReadMessages"];
    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        complectBlock(succeeded, error);
    }];
}

/**
 *  获取未读消息队列
 *
 *  @param completeBlock 回调 Block
 */
- (void)getUnReadMessagesWithcomplete:(void(^)(BOOL succeeded, NSError *error, NSArray *array))completeBlock{
    NSArray *messageArray = [[AVUser currentUser]objectForKey:@"unReadMessages"];
    if (messageArray.count) {
        NSMutableArray *resultArray = [NSMutableArray array];
        for (int i = 0; i < messageArray.count; i++) {
            AVQuery *query = [AVQuery queryWithClassName:@"LTModelMessage"];
            [query whereKey:@"objectId" equalTo:messageArray[i]];
            [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                if (!error) {
                    [resultArray addObject:object];
                    if (resultArray.count == messageArray.count) {//获取到全部的数据
                        completeBlock(YES, nil, resultArray);
                    }
                }
            }];
        }
#warning For 由于本地消息缓存还没写，清空先放着
        //获取完未读消息，清空未读消息字段
        
    }else{
        completeBlock(YES, nil, [NSArray array]);//无数据
    }
}

@end
