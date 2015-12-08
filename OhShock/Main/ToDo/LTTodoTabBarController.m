//
//  LTTodoTabBarController.m
//  OhShock
//
//  Created by Lintao.Yu on 12/7/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTTodoTabBarController.h"
#import "LTTodoAllStyleViewController.h"
#import "LTTodoCalenderStyleViewController.h"
#import "LTTodoTypeStyleViewController.h"
#import "DWBubbleMenuButton.h"

@interface LTTodoTabBarController ()

@property (nonatomic, strong) DWBubbleMenuButton *upMenuView;
@property (nonatomic, strong) UIViewController *calenderStyle;
@property (nonatomic, strong) UIViewController *allStyle;
@property (nonatomic, strong) UIViewController *typeStyle;

@end

@implementation LTTodoTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  @author Lintao Yu, 15-12-07 14:12:24
     *
     *  三种显示模式的初始化
     */
    self.calenderStyle = [LTTodoCalenderStyleViewController new];
    self.allStyle      = [LTTodoAllStyleViewController new];
    self.typeStyle     = [LTTodoTypeStyleViewController new];
    UINavigationController *calenderStyleNavigationController = [[UINavigationController alloc]initWithRootViewController:self.calenderStyle];
    UINavigationController *allStyleNavigationController = [[UINavigationController alloc]initWithRootViewController:self.allStyle];
    UINavigationController *typeStyleNavigationController = [[UINavigationController alloc]initWithRootViewController:self.typeStyle];
    self.viewControllers = @[calenderStyleNavigationController,allStyleNavigationController,typeStyleNavigationController];
    [self setSelectedIndex:0];
    self.tabBar.hidden = YES;
    
    [self createDWBubbleMenuButton];
    
#pragma mark for debug
    self.allStyle.view.backgroundColor = [UIColor redColor];
    self.typeStyle.view.backgroundColor = [UIColor blueColor];
}

#pragma mark - 分类弹出按钮
-(void)createDWBubbleMenuButton{
    // Create up menu button
    UIImageView *homeLabel = [self createHomeButtonView];
    
    _upMenuView = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - CGRectGetWidth(homeLabel.frame) -100,CGRectGetHeight(self.view.frame) - CGRectGetHeight(homeLabel.frame) - 160,homeLabel.frame.size.width,homeLabel.frame.size.height)
                                         expansionDirection:DirectionUp];
    _upMenuView.homeButtonView = homeLabel;
    
    [_upMenuView addButtons:[self createDemoButtonArray]];
    UIPanGestureRecognizer *holdPress = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(upMenuViewHoldPress:)];
    [_upMenuView addGestureRecognizer:holdPress];
    
    [self.view addSubview:_upMenuView];
}
- (UIButton *)createButtonWithName:(NSString *)imageName {
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button sizeToFit];
    
    [button addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}



- (UIImageView *)createHomeButtonView {
    UIImageView *homeView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 40.f, 40.f)];
    [homeView setImage:[UIImage imageNamed:@"multiply_float__touch"]];
    //homeView.backgroundColor = [UIColor blackColor];
    //homeView.layer.cornerRadius = homeView.frame.size.height / 2.f;
    //homeView.backgroundColor =[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
    //homeView.clipsToBounds = YES;
    
    return homeView;
}
- (NSArray *)createDemoButtonArray {
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (NSString *imageName in @[@"multipy_float__all", @"multipy_float__calendar", @"multipy_float__sort"]) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        button.tag = i++;
        
        [button addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonsMutable addObject:button];
    }
    
    return [buttonsMutable copy];
}

- (void)test:(UIButton *)sender {
    NSLog(@"Button tapped, tag: %ld", (long)sender.tag);
    switch (sender.tag) {
        case 0:
            //显示列表查看
            self.selectedIndex = 0;
            self.tabBarController.title = @"按日历查看";
            break;
        case 1:
            //显示日历模式
            self.selectedIndex = 1;
            self.tabBarController.title = @"按列表查看";
            break;
        case 2:
            //显示分类
            self.selectedIndex = 2;
            self.tabBarController.title = @"按分类查看";
            break;
        default:
            break;
    }
}
#pragma mark upMenuView 按住后
-(void)upMenuViewHoldPress:(UIPanGestureRecognizer*) recognizer {
    NSLog(@"x:%f",recognizer.view.frame.size.height);
    CGPoint translation = [recognizer translationInView:self.view];
    
    CGRect recRect = recognizer.view.frame;
    if(CGRectGetMinX(recRect) > 0 && CGRectGetMaxX(recRect) < [UIScreen mainScreen].bounds.size.width &&
       CGRectGetMinY(recRect) > 0 && CGRectGetMaxY(recRect) < self.view.frame.size.height)
    {
        
        CGRect temp = CGRectMake(CGRectGetMinX(recRect)+translation.x, CGRectGetMinY(recRect)+translation.y, CGRectGetWidth(recRect), CGRectGetHeight(recRect));
        
        if (CGRectGetMinX(temp) > 0 && CGRectGetMaxX(temp) < [UIScreen mainScreen].bounds.size.width && CGRectGetMinY(temp) > 0 && CGRectGetMaxY(temp) < ([UIScreen mainScreen].bounds.size.height - 120)) {
            recognizer.view.center = CGPointMake(CGRectGetMidX(recRect) + translation.x,CGRectGetMidY(recRect) + translation.y);
        }
    }
    if (([UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(recognizer.view.frame)-[_upMenuView _combinedButtonHeight]) >= 120 ) {
        _upMenuView.direction = DirectionDown;
    }else{
        _upMenuView.direction = DirectionUp;
    }
    [recognizer setTranslation:CGPointZero inView:self.view];
}


@end
