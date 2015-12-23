//
//  LTChatService.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/16.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTChatService.h"

@interface LTChatService()
/// 接收方
@property (nonatomic, strong) AVUser *toUser;
@end

@implementation LTChatService
-(instancetype)initWithUser:(AVUser *)user{
    self = [super init];
    if (self) {
        _toUser = user;
    }
    return self;
}
#pragma mark - 获取当前用户
- (AVUser *)getCurrentUser{
    return [AVUser currentUser];
}
#pragma mark -  获取用户头像
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
