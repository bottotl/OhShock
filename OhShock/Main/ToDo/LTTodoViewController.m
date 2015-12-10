//
//  LTTodoViewController.m
//  OhShock
//
//  Created by Lintao.Yu on 12/7/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTTodoViewController.h"
#import "LTTodoAllStyleViewController.h"
#import "LTTodoCalenderStyleViewController.h"
#import "LTTodoTypeStyleViewController.h"
#import "DWBubbleMenuButton.h"
#import "UIView+Layout.h"

@interface LTTodoViewController (){
    UIView *_contentView;
}

@property (nonatomic, strong) DWBubbleMenuButton *upMenuView;

@end

@implementation LTTodoViewController

#pragma mark - property

- (UIViewController *)selectedViewController {
    return [[self viewControllers] objectAtIndex:[self selectedIndex]];
}
- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if (selectedIndex >= self.viewControllers.count) {
        return;
    }
    
    if ([self selectedViewController]) {
        [[self selectedViewController] willMoveToParentViewController:nil];
        [[[self selectedViewController] view] removeFromSuperview];
        [[self selectedViewController] removeFromParentViewController];
    }
    
    _selectedIndex = selectedIndex;
    
    [self setSelectedViewController:[[self viewControllers] objectAtIndex:selectedIndex]];
    [self addChildViewController:[self selectedViewController]];
    [[[self selectedViewController] view] setFrame:[[self contentView] bounds]];
    [[self contentView] addSubview:[[self selectedViewController] view]];
    [[self selectedViewController] didMoveToParentViewController:self];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  @author Lintao Yu, 15-12-07 14:12:24
     *
     *  三种显示模式的初始化
     */
    LTTodoCalenderStyleViewController *calenderStyle = [LTTodoCalenderStyleViewController new];
    LTTodoAllStyleViewController *allStyle           = [LTTodoAllStyleViewController new];
    LTTodoTypeStyleViewController *typeStyle         = [LTTodoTypeStyleViewController new];
    [self.view addSubview:[self contentView]];
    UINavigationController *calenderStyleNavigationController = [[UINavigationController alloc]initWithRootViewController:calenderStyle];
    UINavigationController *allStyleNavigationController = [[UINavigationController alloc]initWithRootViewController:allStyle];
    UINavigationController *typeStyleNavigationController = [[UINavigationController alloc]initWithRootViewController:typeStyle];
    
    self.viewControllers = @[calenderStyleNavigationController,allStyleNavigationController,typeStyleNavigationController];
    
    [self setSelectedIndex:0];
    [self createDWBubbleMenuButton];
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

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        _contentView.size = self.view.size;
        _contentView.left = self.view.left;
        _contentView.top  = self.view.top;

    }
    return _contentView;
}

//-(void)updateViewConstraints{
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottomMargin.right.top.equalTo(self.view);
//    }];
//    
//    [super updateViewConstraints];
//}

@end
