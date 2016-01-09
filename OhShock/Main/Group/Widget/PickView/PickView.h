//
//  PickView.h
//  zsp
//
//  Created by chenLong on 15/6/3.
//  Copyright (c) 2015年 chenLong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickDelegate <NSObject>

-(void)cancel;
-(void)ensure;

@end

@interface PickView : UIView
@property (strong, nonatomic) IBOutlet UIPickerView *myPicker;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *ensureButton;
@property (strong, nonatomic) id<PickDelegate> delegate;

@end
