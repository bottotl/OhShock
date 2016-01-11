//
//  GroupIntroductionViewController.m
//  OhShock
//
//  Created by chenlong on 16/1/11.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "GroupIntroductionViewController.h"
#import "Header.h"
#import "SVProgressHUD.h"

@interface GroupIntroductionViewController ()

@end

@implementation GroupIntroductionViewController{
    UITextView *mainTextView;
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
    
    mainTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 200)];
    mainTextView.text = _introduction;
    [self.view addSubview:mainTextView];
    
    UIImageView *tipView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 210, kScreen_Width, 200)];
    tipView.image = [UIImage imageNamed:@"intro_icon_2"];
    [self.view addSubview:tipView];
}

- (void)viewWillAppear:(BOOL)animated{
    self.title = @"群介绍";
}

- (void)done{
    if (![self isBlankString:mainTextView.text]) {
        if (_doneBlock) {
            _doneBlock(mainTextView.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [SVProgressHUD showErrorWithStatus:@"群介绍不能为空！"];
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
