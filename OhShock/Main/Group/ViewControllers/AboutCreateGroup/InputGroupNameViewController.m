//
//  InputGroupNameViewController.m
//  OhShock
//
//  Created by chenlong on 16/1/9.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "InputGroupNameViewController.h"
#import "Header.h"
#import "SVProgressHUD.h"

@interface InputGroupNameViewController ()

@end

@implementation InputGroupNameViewController{
    UITextField *inputField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBCOLOR(239, 239, 244);
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(done)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIView *whiteBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreen_Width, 44)];
    whiteBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteBackView];
    
    inputField = [[UITextField alloc]initWithFrame:CGRectMake(10, 7, kScreen_Width - 20, 30)];
    inputField.placeholder = @"输入群名";
    inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [inputField becomeFirstResponder];
    [whiteBackView addSubview:inputField];
    
    UIImageView *tipView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 70, kScreen_Width, 200)];
    tipView.image = [UIImage imageNamed:@"intro_icon_2"];
    [self.view addSubview:tipView];
}

- (void)viewWillAppear:(BOOL)animated{
    self.title = @"输入标题";
}

- (void)done{
    if (![self isBlankString:inputField.text]) {
        if (_doneBlock) {
            _doneBlock(inputField.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [SVProgressHUD showErrorWithStatus:@"群名不能为空！"];
        return;
    }
}

//判断字符串是否为空（包括全为空格）
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
