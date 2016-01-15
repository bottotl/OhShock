//
//  LTGroupInfoViewController.m
//  OhShock
//
//  Created by chenlong on 16/1/6.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTGroupInfoViewController.h"
#import "XHPopMenu.h"
#import "DVSwitch.h"
#import "Header.h"
#import "LTDiscoverTodoViewController.h"
#import "LTGroupMemberViewController.h"
#import "LTGroupService.h"
#import "SVProgressHUD.h"

@interface LTGroupInfoViewController ()

@property (nonatomic, strong) XHPopMenu *popMenu;
@property (nonatomic, strong) DVSwitch *switcher;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) LTGroupService *groupService;

@end

@implementation LTGroupInfoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addChildController];
    //添加导航栏右侧更多按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"moreBtn_Nav"]
                           forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(showMenuOnView:)forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 30, 20);
    
    UIBarButtonItem *rMenuButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rMenuButton;

    //添加scrollview
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 35, kScreen_Width, kScreen_Height - 35)];
    _mainScrollView.contentSize = CGSizeMake(2 * kScreen_Width, 0);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.scrollEnabled = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.bounces = NO;
    [self.view addSubview:_mainScrollView];
    
    UIViewController *vc1 = [self.childViewControllers firstObject];
    vc1.view.frame =CGRectMake(0, 0, kScreen_Width, _mainScrollView.frame.size.height);
    [_mainScrollView addSubview:vc1.view];
    
    UIViewController *vc2 = [self.childViewControllers lastObject];
    vc2.view.frame = CGRectMake(kScreen_Width, 0, kScreen_Width, _mainScrollView.frame.size.height);
    [_mainScrollView addSubview:vc2.view];

    
    __block UIScrollView *scrollViewSelf = _mainScrollView;
    
    //添加选项卡控件
    self.switcher = [[DVSwitch alloc] initWithStringsArray:@[@"成员", @"日程"]];
    self.switcher.frame = CGRectMake(-1, 0, kScreen_Width+2, 35);
    self.switcher.labelTextColorOutsideSlider = [UIColor colorWithRed:35/255.0 green:140/255.0 blue:0 alpha:1];
    self.switcher.sliderColor =[UIColor colorWithRed:35/255.0 green:140/255.0 blue:0 alpha:1];
    self.switcher.backgroundColor = [UIColor whiteColor];
    self.switcher.cornerRadius = 0;
    self.switcher.layer.borderColor = [UIColor blackColor].CGColor;
    self.switcher.layer.borderWidth = 1;
    self.switcher.handlerBlock = ^(NSUInteger index){
        NSLog(@"%ld", (long)index);
        [UIView animateWithDuration:0.2 animations:^{
            scrollViewSelf.contentOffset = CGPointMake(index * kScreen_Width, 0);
        }];
    };
    [self.view addSubview:self.switcher];
    
    _groupService = [[LTGroupService alloc]init];
}

- (void)viewWillAppear:(BOOL)animated{
    self.title = _groupName;
}

//添加子控制器
- (void)addChildController{
    LTGroupMemberViewController *memberController = [[LTGroupMemberViewController alloc]init];
    [self addChildViewController:memberController];
    
    LTDiscoverTodoViewController *todoController = [[LTDiscoverTodoViewController alloc]init];
    [self addChildViewController:todoController];
}

#pragma mark “添加按钮”回调

- (IBAction)showMenuOnView:(UIBarButtonItem *)buttonItem {
    [self.popMenu showMenuOnView:self.navigationController.view atPoint:CGPointZero];
}
#pragma mark config popMenu
- (XHPopMenu *)popMenu {
    if (!_popMenu) {
        NSMutableArray *popMenuItems = [[NSMutableArray alloc] initWithCapacity:3];
        for (int i = 0; i < 3; i ++) {
            NSString *imageName;
            NSString *title;
            switch (i) {
                case 0: {
                    imageName = @"contacts_add_newmessage";
                    title = @"分享该群";
                    break;
                }
                case 1: {
                    imageName = @"contacts_add_friend";
                    title = @"查看群资料";
                    break;
                }
                case 2:{
                    imageName = @"contacts_add_friend";
                    title = @"加入该群";
                }
                default:
                    break;
            }
            XHPopMenuItem *popMenuItem = [[XHPopMenuItem alloc] initWithImage:[UIImage imageNamed:imageName] title:title];
            [popMenuItems addObject:popMenuItem];
        }
        
        __weak __typeof(self) weakSelf = self;
        _popMenu = [[XHPopMenu alloc] initWithMenus:popMenuItems];
        _popMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem *popMenuItems) {
            if (index == 1) {
               
            }else if (index == 0 ) {

            }else if (index == 2 ) {
                [weakSelf joinGroup];
            }
            
        };
    }
    return _popMenu;
}

#pragma mark 更多按钮包含的方法

//加入该群
- (void)joinGroup{
    [_groupService joinGroupWith:_group andCallback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SVProgressHUD showSuccessWithStatus:@"申请成功"];
        }
    }];
}

@end
