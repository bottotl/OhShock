//
//  LTPostCell.h
//  OhShock
//
//  Created by Lintao.Yu on 16/1/3.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTPostProfileView.h"
#import "LTPostContentView.h"
#import "LTPostImagesView.h"

//typedef NS_OPTIONS(NSUInteger, LTPostCellStyle){
//    LTPostCellStyleReportImage = 0 << 1
//};
//


@class LTPostLayout;

static NSString *const LTPostCellIdentifier = @"LTPostCell";
@interface LTPostCell : UITableViewCell

@property (nonatomic, strong) LTPostProfileView *profileView;

@property (nonatomic, strong) LTPostContentView *ltContentView;

@property (nonatomic, strong) LTPostImagesView *imagesView;

@property (nonatomic, weak) LTPostLayout *layout;

@end
