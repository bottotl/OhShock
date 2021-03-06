//
//  LTMeHeadUserImageView.h
//  OhShock
//
//  Created by Lintao.Yu on 12/8/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTTapImageView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

static CGFloat const LTMeHeadUserImageViewHeigthAndWidth = 100;
@protocol LTMeHeadUserImageDelegate;
/**
 *  @author Lintao Yu, 15-12-08 17:12:35
 *
 *  用来显示用户头像对应的图片
 *  本控件对大小进行限定 如果要修改直接修改
    LTMeHeadUserImageViewHeigthAndWidth
 */
@interface LTMeHeadUserImageView : LTTapImageView
/// 用户头像对应的 url
@property (nonatomic, strong) NSString *avatorUrlString;
@property (nonatomic, weak) id<LTMeHeadUserImageDelegate> delegate;
- (RACSignal *)rac_gestureSignal;
@end

@protocol LTMeHeadUserImageDelegate <NSObject>

-(void)LTMeHeadUserImageViewOnClick;

@end

