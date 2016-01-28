//
//  LTModelPost.m
//  OhShock
//
//  Created by lintao.yu on 16/1/15.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTModelPost.h"

@implementation LTModelPost
@dynamic pubUser, content,likedUser, comments, photos, thumbPhotos;
+ (NSString *)parseClassName {
    return @"Post";
}
-(id)copyWithZone:(NSZone *)zone{
    LTModelPost *copy = [[[self class]allocWithZone:zone]init];
    copy.pubUser = self.pubUser;
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSRTFTextDocumentType};
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithData:self.content options:options documentAttributes:nil error:nil];
    [content appendAttributedString:[[NSAttributedString alloc]initWithString:@"sa🐶"]];
    copy.content = [content dataFromRange:NSMakeRange(0, content.length)
                       documentAttributes:@{NSDocumentTypeDocumentAttribute : NSRTFTextDocumentType }
                                    error:nil];
    copy.likedUser = self.likedUser;
    copy.comments = self.comments;
    copy.photos = self.photos;
    copy.thumbPhotos = self.thumbPhotos;
    return copy;
}
@end
