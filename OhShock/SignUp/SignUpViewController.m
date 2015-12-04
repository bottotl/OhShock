//
//  SignUpViewController.m
//  OhShock
//
//  Created by Lintao.Yu on 12/4/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "SignUpViewController.h"
#import "UIView+Layout.h"
#import "TPKeyboardAvoidingScrollView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LTSignUpService.h"
#import <AVOSCloud/AVOSCloud.h>

static CGFloat logoImageViewHeight = 60;
static CGFloat logoImageViewWidth = 60;
static CGFloat inputTextFieldHeight = 30 ;
static NSString * logInBtnColor = @"#4F68D7";

@interface SignUpViewController ()

/// 用来放置其他控件
@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;
/// 显示 logo
@property (nonatomic, strong) UIImageView *logoImageView;
/// 账号输入框
@property (nonatomic, strong) UITextField *accountTextField;
/// 密码输入框
@property (nonatomic, strong) UITextField *passwordTextField;
/// 登陆按钮
@property (nonatomic, strong) UIButton *signupButton;
/// 用于发送登陆请求
@property (nonatomic, strong) LTSignUpService *signUpService;
/// 取消按钮
@property (nonatomic, strong) UIButton *cancleButton;
/// 忘记密码按钮
@property (nonatomic, strong) UIButton *forgetButton;

@end

@implementation SignUpViewController

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    self.signUpService = [LTSignUpService new];
    
    UIImageView *backgroundImage = [[UIImageView alloc]initWithImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    backgroundImage.frame = [[UIScreen mainScreen] bounds];
    [self.view addSubview:backgroundImage];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(1, 0, 0, 0);
    self.scrollView = [[TPKeyboardAvoidingScrollView alloc]init];
    self.scrollView.bounces = YES;
    self.scrollView.showsHorizontalScrollIndicator = FALSE;
    self.scrollView.showsVerticalScrollIndicator = FALSE;
    [self.view addSubview:self.scrollView];
    [self.scrollView setContentSize:self.view.size];
    self.scrollView.contentInset = inset;
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.view.mas_top);
    }];
    
    self.logoImageView = [UIImageView new];
    self.logoImageView.image = [UIImage imageNamed:@"Sun"];
    
    [self.scrollView addSubview:self.logoImageView];
    
    self.accountTextField = [UITextField new];
    self.accountTextField.placeholder = @"请输入账号";
    self.accountTextField.backgroundColor = [UIColor whiteColor];
    self.accountTextField.adjustsFontSizeToFitWidth = YES;
    // 为了左边空出一点
    self.accountTextField.leftViewMode = UITextFieldViewModeAlways;
    self.accountTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0.1)];
    [self.scrollView addSubview:self.accountTextField];
    
    self.passwordTextField = [UITextField new];
    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.backgroundColor = [UIColor whiteColor];
    self.passwordTextField.adjustsFontSizeToFitWidth = YES;
    // 为了左边空出一点
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0.1)];
    [self.scrollView addSubview:self.passwordTextField];
    
    self.signupButton = [UIButton new];
    [self.signupButton setBackgroundColor:[UIColor redColor]];
    [self.signupButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self.signupButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.signupButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.scrollView addSubview:self.signupButton];
    
    self.cancleButton = [UIButton new];
    [self.cancleButton setBackgroundColor:[UIColor clearColor]];
    [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:self.cancleButton];
    
    self.forgetButton = [UIButton new];
    [self.forgetButton setBackgroundColor:[UIColor clearColor]];
    [self.forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.forgetButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:self.forgetButton];
    
#pragma mark 信号初始化
    RACSignal *validAccountSignal =
    [self.accountTextField.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidAccount:text]);
     }];
    RACSignal *validPasswordSignal =
    [self.passwordTextField.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidPassword:text]);
     }];
    RACSignal *signUpActiveSignal =
    [RACSignal combineLatest:@[validAccountSignal, validPasswordSignal]
                      reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid){
                          return @([usernameValid boolValue]&&[passwordValid boolValue]);
                      }];
    
    [signUpActiveSignal subscribeNext:^(NSNumber *signupActive){
        NSLog(@"signUpActiveSignal");
        self.signupButton.enabled =[signupActive boolValue];
    }];
#pragma mark -- 登陆按钮点击信号
    [[[[self.signupButton
        rac_signalForControlEvents:UIControlEventTouchUpInside]
       doNext:^(id x) {
           self.signupButton.enabled = NO;
           self.signupButton.backgroundColor = [UIColor whiteColor];
       }]
      flattenMap:^id(id x){
          return[self signUpSignal];
      }]
     subscribeNext:^(id x){
         NSLog(@"Sign up result: %@", x);
         self.signupButton.enabled = YES;
         self.signupButton.backgroundColor = [UIColor redColor];
         if ([x isKindOfClass:[NSError class]]) {
             NSLog(@"error: %@",x);
         }else{
             NSLog(@"注册信息: %@",x);
         }
         
     }];
    
    [[[self.cancleButton rac_signalForControlEvents:UIControlEventTouchUpInside]
      doNext:^(id x) {
          //self.cancleButton.enabled = FALSE;
      }]subscribeNext:^(id x) {
          [self dismissViewControllerAnimated:YES completion:nil];
          //self.cancleButton.enabled = YES;
      }];
    
}
#pragma mark - layout

-(void)viewDidLayoutSubviews{
    self.logoImageView.size       = CGSizeMake(logoImageViewHeight, logoImageViewWidth);
    self.logoImageView.centerX    = self.scrollView.centerX;
    self.logoImageView.centerY    = self.scrollView.height * 1/5;
    
    self.accountTextField.height  = inputTextFieldHeight;
    self.accountTextField.width   = self.scrollView.width * 2/3;
    self.accountTextField.centerX = self.scrollView.centerX;
    self.accountTextField.top     = self.logoImageView.bottom + 20;
    self.accountTextField.layer.cornerRadius  = self.accountTextField.height / 5 ;
    
    self.passwordTextField.height  = inputTextFieldHeight;
    self.passwordTextField.width   = self.scrollView.width * 2/3;
    self.passwordTextField.centerX = self.scrollView.centerX;
    self.passwordTextField.top     = self.accountTextField.bottom + 5;
    self.passwordTextField.layer.cornerRadius  = self.passwordTextField.height / 5 ;
    
    self.signupButton.height  = inputTextFieldHeight;
    self.signupButton.width   = self.scrollView.width * 2/3;
    self.signupButton.top     = self.passwordTextField.bottom + 20;
    self.signupButton.centerX = self.scrollView.centerX;
    self.signupButton.layer.cornerRadius = self.signupButton.height/2;
    
    self.cancleButton.height = inputTextFieldHeight;
    self.cancleButton.width = 60;
    self.cancleButton.left = 20;
    self.cancleButton.top = 50;
    
    self.forgetButton.height = inputTextFieldHeight;
    self.forgetButton.width = 100;
    self.forgetButton.left = 20;
    self.forgetButton.bottom = self.view.bottom - 50 ;
    
}

#pragma mark - 账号密码输入合法性验证逻辑
/**
 *  判断账号输入是否合法
 *
 *  @param account 账号
 *
 *  @return 是否合法
 */
- (BOOL)isValidAccount:(NSString *)account{
    if (account.length >= 1) {
        //NSLog(@"账号长度大于等于1");
        return YES;
    }else{
        return FALSE;
    }
}

/**
 *  判断密码输入是否合法
 *
 *  @param password 密码
 *
 *  @return 是否合法
 */
- (BOOL)isValidPassword:(NSString *)password{
    if (password.length >= 1) {
        //NSLog(@"密码长度大于等于1");
        return YES;
    }else{
        return FALSE;
    }
}
#pragma mark - 登陆信号
- (RACSignal *)signUpSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        [self.signUpService signUpWithAccount:self.accountTextField.text password:self.passwordTextField.text email:@"377632523@qq.com" phone:nil complete:^(BOOL succeeded, NSError * _Nullable error) {
            if (!error) {
                [subscriber sendNext:@(succeeded)];
                [subscriber sendCompleted];
            }else{
                [subscriber sendNext:error];
                [subscriber sendCompleted];
            }
            
        }];
        
        return nil;
    }];
}

@end
