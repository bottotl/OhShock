//
//  IntroductionViewController.m
//  OhShock
//
//  Created by Lintao.Yu on 12/3/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "IntroductionViewController.h"
#import "UIView+Layout.h"
#import "LogInViewController.h"

@interface IntroductionViewController ()

@property (strong, nonatomic) UIButton  *registerBtn;
@property (strong, nonatomic) UIButton  *loginBtn;

@end

@implementation IntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor  *darkColor = [UIColor colorWithHexString:@"0x28303b"];
    
    CGFloat buttonHeight = 40;
    self.registerBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(registerBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
        
        button.backgroundColor = darkColor;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"注册" forState:UIControlStateNormal];
        
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 1.0;
        button.layer.borderColor = darkColor.CGColor;
        button;
    });
    self.loginBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(loginBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
        
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [button setTitleColor:darkColor forState:UIControlStateNormal];
        [button setTitle:@"登录" forState:UIControlStateNormal];
        
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 1.0;
        button.layer.borderColor = darkColor.CGColor;
        button;
    });
    
    [self.view addSubview:self.registerBtn];
    [self.view addSubview:self.loginBtn];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_leftMargin).offset(10);
        make.right.equalTo(self.view.mas_centerX).offset(-10);
        make.bottom.equalTo(self.view.mas_bottomMargin).offset(-20);
        make.height.equalTo(@(buttonHeight));
        self.registerBtn.layer.cornerRadius = buttonHeight/2;
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_rightMargin).offset(-10);
        make.left.equalTo(self.view.mas_centerX).offset(10);
        make.bottom.equalTo(self.view.mas_bottomMargin).offset(-20);
        make.height.equalTo(@(buttonHeight));
        self.loginBtn.layer.cornerRadius = buttonHeight/2;
    }];
    
}

- (void)registerBtnOnClick{
    
}
- (void)loginBtnOnClick{
    LogInViewController *logInViewController = [LogInViewController new];
    [self showDetailViewController:logInViewController sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
