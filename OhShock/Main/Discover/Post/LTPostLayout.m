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

-(void)layout{
    _height = 0;
    _height += [LTPostProfileView viewHeight];

}
-(CGFloat)layoutHeight{
    [self layout];
    return _height;
}
@end
