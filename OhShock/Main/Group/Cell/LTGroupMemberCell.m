//
//  LTGroupMemberCell.m
//  OhShock
//
//  Created by chenlong on 16/1/28.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTGroupMemberCell.h"
#import "Header.h"
#import "LTChatService.h"
#import "UIImageView+WebCache.h"

@implementation LTGroupMemberCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatarImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 46, 46)];
        _avatarImg.layer.masksToBounds = YES;
        _avatarImg.layer.cornerRadius = 23;
        [self.contentView addSubview:_avatarImg];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 60, 60, 13.5)];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textAlignment= NSTextAlignmentCenter;
        [self.contentView addSubview:_nameLabel];
        
        UIView *grayBack = [[UIView alloc]initWithFrame:CGRectMake(69, 8, kScreen_Width - 75, 64)];
        grayBack.layer.masksToBounds = YES;
        grayBack.layer.cornerRadius = 10;
        grayBack.backgroundColor = RGBCOLOR(240, 240, 240);
        [self.contentView addSubview:grayBack];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 8, grayBack.width - 70, 48)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.text = @"出去溜达溜达。哈哈哈出去溜达溜达。哈哈哈出去溜达溜达。哈哈哈";
        [grayBack addSubview:_contentLabel];
        
        _contentImg = [[UIImageView alloc]initWithFrame:CGRectMake(_contentLabel.right + 8, 7, 53, 54)];
        _contentImg.image = [UIImage imageNamed:@"Sun"];
        [grayBack addSubview:_contentImg];
    }
    return self;
}

- (void)setCellWith:(AVObject *)obj{
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:[obj objectForKey:@"objectId"]];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            LTChatService *service = [[LTChatService alloc]init];
            [service getAvatorUrlString:(AVUser *)object complete:^(NSString *urlString, NSError *error) {
                if (!error) {
                    [_avatarImg sd_setImageWithURL:[NSURL URLWithString:urlString]];
                }
            }];
             _nameLabel.text = [object objectForKey:@"username"];
        }
    }];
}

@end
