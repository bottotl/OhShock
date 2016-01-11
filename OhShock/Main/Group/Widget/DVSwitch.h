//
//  DVSwitch.h
//  DVSwitcherExample
//
//  Created by Dmitry Volevodz on 08.10.14.
//  Copyright (c) 2014 Dmitry Volevodz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVSwitch : UIControl

@property (strong, nonatomic) UIColor *backgroundColor; // defaults to gray
@property (strong, nonatomic) UIColor *sliderColor; // defaults to white
@property (strong, nonatomic) UIColor *labelTextColorInsideSlider; // defaults to black
@property (strong, nonatomic) UIColor *labelTextColorOutsideSlider; // defaults to white
@property (strong, nonatomic) UIFont *font;
@property (nonatomic) CGFloat cornerRadius; // defaults to 12
@property (nonatomic) CGFloat sliderOffset; // slider offset from background, top, bottom, left, right


@property (strong, nonatomic) NSMutableArray *labels;
@property (strong, nonatomic) NSMutableArray *onTopLabels;
@property (strong, nonatomic) NSArray *strings;

@property (strong, nonatomic) void (^handlerBlock)(NSUInteger index);
@property (strong, nonatomic) void (^willBePressedHandlerBlock)(NSUInteger index);

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *sliderView;

@property (nonatomic) NSInteger selectedIndex;

+ (instancetype)switchWithStringsArray:(NSArray *)strings;
- (instancetype)initWithStringsArray:(NSArray *)strings;
- (void)animateChangeToIndex:(NSUInteger)selectedIndex;
- (void)changeToIndexWithoutAnimation:(NSUInteger)selectedIndex;
- (void)forceSelectedIndex:(NSInteger)index animated:(BOOL)animated; // sets the index, also calls handler block

// This method sets handler block that is getting called after the switcher is done animating the transition

- (void)setPressedHandler:(void (^)(NSUInteger index))handler;


// This method sets handler block that is getting called right before the switcher starts animating the transition

- (void)setWillBePressedHandler:(void (^)(NSUInteger index))handler;


@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
