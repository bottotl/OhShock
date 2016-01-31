//
//  CLChatRoomVC.m
//  OhShock
//
//  Created by chenlong on 16/1/31.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "CLChatRoomVC.h"

@interface CLChatRoomVC ()

@end

@implementation CLChatRoomVC

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
    [super viewDidLoad];
    UIImage *_peopleImage = [UIImage imageNamed:@"chat_menu_people"];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:_peopleImage style:UIBarButtonItemStyleDone target:self action:@selector(goChatGroupDetail:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)goChatGroupDetail:(id)sender {
    DLog(@"click");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
