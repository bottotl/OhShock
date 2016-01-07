//
//  LTPostImagesView.m
//  OhShock
//
//  Created by Lintao.Yu on 1/6/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import "LTPostImagesView.h"
#import "UIView+Layout.h"

static const CGFloat imageHeightNormal = 80;
static const CGFloat LTPostImagesViewPadding = 5;

@interface LTPostImagesView ()

@property (nonatomic, assign) CGFloat imageHeight;

@end

@implementation LTPostImagesView

- (instancetype)init
{
    self = [self initWithFrame:CGRectMake(0, 0, MScreenWidth - LTPostImagesViewPadding * 2, 0)];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)layoutSubviews{
    CGFloat height;
    if (0 < self.images.count ) {
        height += 60;
    }
    if (3 < self.images.count) {
        height += 60;
    }
    
    self.width = MScreenWidth ;
    
    self.size = CGSizeMake(MScreenWidth - LTPostImagesViewPadding * 2, height);
    self.backgroundColor = [UIColor redColor];
    [super layoutSubviews];
}

-(CGFloat)imageHeight{
//    CGFloat imageHeight;
//    switch (self.type) {
//        case LTPostImagesViewTypeNormal:
//            imageHeight = imageHeightNormal;
//            break;
//        case LTPostImagesViewTypeReport:
//            imageHeight = imageHeightReport;
//            break;
//    }
    return imageHeightNormal;
}

#pragma mark - 高度计算
+(CGFloat)viewHeightWithImages:(NSArray *)images{
    
    CGFloat height = 0;
    NSUInteger imageCount = 0;
    
    if (images) {
        imageCount = images.count;
    }
    
    if (imageCount > 0 && imageCount < 4) {
        height += imageHeightNormal;
    }
    if (imageCount >= 4) {
        height += imageHeightNormal;
    }
//    switch (type) {
//        case LTPostImagesViewTypeNormal:{
//            if (imageCount > 0 && imageCount < 4) {
//                height += imageHeightNormal;
//            }
//            if (imageCount >= 4) {
//                height += imageHeightNormal;
//            }
//        }
//            break;
//        case LTPostImagesViewTypeReport:{
//            if (imageCount > 0 && imageCount < 4) {
//                height += imageHeightReport;
//            }
//            if (imageCount >= 4) {
//                height += imageHeightReport;
//            }
//        }
//            break;
//    }
    
    return height;
}
@end


@implementation LTPostImagesCollectionViewCell



@end