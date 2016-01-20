//
//  LTPostLikedView.h
//  OhShock
//
//  Created by Lintao.Yu on 1/9/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  显示谁点了赞
 */
@interface LTPostLikedView : UIView

@property (nonatomic, strong) NSAttributedString *usersName;///< 包含所有用户名的富文本 eg:（💗A , B ,C …… ）

/**
 *  计算高度
 *
 *  @param usersName 包含所有用户名的富文本 eg:（💗A , B ,C …… ）
 *  @param width     期望的宽度
 *
 *  @return 高度
 */
+(CGFloat)heightWithUsersName:(NSAttributedString *)usersName andWith:(CGFloat)width;

@end
