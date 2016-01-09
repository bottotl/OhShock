//
//  LTPostLikedView.h
//  OhShock
//
//  Created by Lintao.Yu on 1/9/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTPostLikedModel.h"

/**
 *  显示谁点了赞
 */
@interface LTPostLikedView : UIView

@property (nonatomic, strong) LTPostLikedModel *data;

/// 计算高度
+(CGFloat)heightWithUsersName:(NSAttributedString *)usersName andWith:(CGFloat)width;

@end
