//
//  LTMeHeadUserInfoView.h
//  OhShock
//
//  Created by Lintao.Yu on 12/8/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Male,
    Female,
    UnKnow,
} LTMeHeadUserSex;

static CGFloat const LTMeHeadUserInfoViewHeight = 30;
static CGFloat const LTMeHeadUserInfoViewWidth = 90;
static CGFloat const LTMeHeadUserInfoSexImageHeight = 20;

/**
 *  @author Lintao Yu, 15-12-08 17:12:45
 *
 *  本控件对高度&宽度进行了限定,要修改直接修改
    LTMeHeadUserInfoViewHeight or LTMeHeadUserInfoViewWidth
 */
@interface LTMeHeadUserInfoView : UIView

@property (nonatomic, copy) NSString *userName;
@property (nonatomic) LTMeHeadUserSex userSex;

@end
