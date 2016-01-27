//
//  JoinGroupCell.m
//  OhShock
//
//  Created by chenlong on 16/1/15.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "JoinGroupCell.h"
#import "Header.h"
#import "UIImageView+WebCache.h"
#import "LTChatService.h"
#import "JSQMessagesTimestampFormatter.h"

@implementation JoinGroupCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatar = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        _avatar.layer.masksToBounds = YES;
        _avatar.layer.cornerRadius = 20;
        [self.contentView addSubview:_avatar];
        
        _userName = [[UILabel alloc]initWithFrame:CGRectMake(58, 9, kScreen_Width - 78, 21)];
        _userName.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_userName];
        
        _message = [[UILabel alloc]initWithFrame:CGRectMake(58, 35, kScreen_Width - 78, 16)];
        _message.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_message];
        
        _time = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width - 68, 8, 60, 21)];
        _time.textAlignment = NSTextAlignmentRight;
        _time.textColor = RGBCOLOR(205, 205, 228);
        _time.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_time];
    }
    return self;
}

- (void)setCellWithMessage:(LTModelMessage *)message{
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:[[message objectForKey:@"sendFrom"] objectForKey:@"objectId"]];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {//得到消息发出方
        if (!error) {
            LTChatService *service = [[LTChatService alloc]init];
            [service getAvatorUrlString:(AVUser *)object complete:^(NSString *urlString, NSError *error) {
                if (!error) {
                    [_avatar sd_setImageWithURL:[NSURL URLWithString:urlString]];
                }
            }];
            //查询有延迟，所以在查询完毕后一起展示
            _userName.text = [object objectForKey:@"username"];
            _message.text = [message objectForKey:@"content"];
            _time.attributedText = [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:[message objectForKey:@"createdAt"]];
        }
    }];
}

@end
