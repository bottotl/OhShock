//
//  LTModelPostComment+NSAttributedString.m
//  OhShock
//
//  Created by lintao.yu on 16/2/2.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTModelPostComment+NSAttributedString.h"
#import "UIColor+expanded.h"
#import "LTModelUser.h"

@implementation LTModelPostComment (NSAttributedString)
-(NSAttributedString *)toAttributedString{
    [AVObject fetchAllIfNeeded:@[self.toUser,self.fromUser]];
    NSString *fromUserName = self.fromUser.username;
    NSString *toUserName = self.toUser.username;
    NSString *commentContent = self.content;
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    
    if (fromUserName.length) {
        NSAttributedString *fromUser = [[NSAttributedString alloc] initWithString:fromUserName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"446889"], NSParagraphStyleAttributeName : style}];
        [text appendAttributedString:fromUser];
    }
    if (toUserName.length) {
        NSAttributedString *returnKey = [[NSAttributedString alloc] initWithString:@"回复" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"], NSParagraphStyleAttributeName : style}];
        [text appendAttributedString:returnKey];
        
        NSAttributedString *toUser = [[NSAttributedString alloc] initWithString:toUserName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"446889"], NSParagraphStyleAttributeName : style}];
        //                _toUserRange = NSMakeRange(self.fromUserRange.length + 2, comment.toUser.userName.length);
        [text appendAttributedString:toUser];
    }
    if (commentContent.length) {
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@":%@",commentContent] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"], NSParagraphStyleAttributeName : style}]];
    }
    return text;

}
@end
