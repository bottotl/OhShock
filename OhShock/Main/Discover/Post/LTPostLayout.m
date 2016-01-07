//
//  LTPostLayout.m
//  OhShock
//
//  Created by Lintao.Yu on 16/1/3.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTPostLayout.h"
#import "LTPostProfileView.h"
#import "LTPostContentView.h"
#import "LTPostImagesView.h"
#import "UIView+Layout.h"


#import "WBModel.h"
@interface LTPostLayout(){
    CGFloat _height;
}
@end

@implementation LTPostLayout
//
//- (id)copyWithZone:(NSZone *)zone {
//    LTPostLayout *one = [self.class new];
//    one->_height = _height;
//    one.profileModel = [LTPostProfileViewModel new];
//    one.profileModel.avatarUrlString = [
//    one->_paddingBottom = _paddingBottom;
//    one->_lineHeightMultiple = _lineHeightMultiple;
//    return one;
//}
-(void)layout{
    _height = 0;
    _height += [LTPostProfileView viewHeight];
//    
//    NSData *data = [NSData dataNamed:[NSString stringWithFormat:@"weibo_1.json"]];
//    WBTimelineItem *item = [WBTimelineItem modelWithJSON:data];
//    for (WBStatus *status in item.statuses) {
//        NSLog(@"%@",status.text);
//    }

    _height += [LTPostContentView viewHeightWithContent:[[NSAttributedString alloc]initWithString:@"回复@煒傑_湯:我今天刚好看到一句话：“iPad Pro 不是给现在的笔记本电脑用户的。这是给触屏时代用户的未来笔记本电脑”。iOS 在迈入第9代时终于长大了，分屏操作让它能做更多以前不能做的事，你也可以找到海量适合触屏操作的软件。如果你的工作用到触屏－我建议你尝试 iPad Pro 而不是 MacBook Pro"] width:(MScreenWidth - LTPostContentLabelPadding * 2)];
    _height += [LTPostImagesView viewHeightWithImages:@[@"http://ww2.sinaimg.cn/mw690/6b5f103fgw1ezootytakgj20p00p048x.jpg"
                                                        ,@"http://ww2.sinaimg.cn/mw690/6b5f103fgw1ezootytakgj20p00p048x.jpg"
                                                        ,@"http://ww2.sinaimg.cn/mw690/6b5f103fgw1ezootytakgj20p00p048x.jpg"
                                                        ,@"http://ww2.sinaimg.cn/mw690/6b5f103fgw1ezootytakgj20p00p048x.jpg"].copy];
}
-(CGFloat)layoutHeight{
    [self layout];
    return _height;
}
@end
