//
//  LTPostProfileView.h
//  OhShock
//
//  Created by Lintao.Yu on 16/1/5.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTPostProfileView : UIView
-(void)setAvatatImageWithUrlString:(NSString *)avatarUrlString;
-(void)setName:(NSString *)name;
+(CGFloat)viewHeight;
@end
