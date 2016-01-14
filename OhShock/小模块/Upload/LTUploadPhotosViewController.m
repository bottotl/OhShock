//
//  LTUploadPhotosViewController.m
//  OhShock
//
//  Created by lintao.yu on 16/1/14.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTUploadPhotosViewController.h"
#import "LTUploadTextAndPhotosCell.h"
#import "LTBaseTableViewCell.h"


@interface LTUploadPhotosViewController ()<UITableViewDataSource, UITableViewDelegate, AddPhotoDelegae>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *photos;

@end

@implementation LTUploadPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.frame = self.view.bounds;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[LTUploadTextAndPhotosCell class] forCellReuseIdentifier:LTUploadTextAndPhotosCellIdentifier];
    [_tableView registerClass:[LTBaseTableViewCell class] forCellReuseIdentifier:LTBaseTableViewCellIdentifier];
    
    UIBarButtonItem *cancleButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleUpload)];
    self.navigationItem.leftBarButtonItem = cancleButton;
    
    UIImage *photo = [UIImage imageNamed:@"tabbar_selected"];
    self.photos = @[photo,photo,photo,photo,photo];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
        return 2;
    if (section == 1) {
        return 2;
    }
    return 0;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0 && indexPath.row == 0) {
        LTUploadTextAndPhotosCell *cell = [tableView dequeueReusableCellWithIdentifier:LTUploadTextAndPhotosCellIdentifier forIndexPath:indexPath];
        cell.richView.degate = self;
        return cell;
    }
    cell = [tableView dequeueReusableCellWithIdentifier:LTBaseTableViewCellIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        LTUploadTextAndPhotosCell *tCell = (LTUploadTextAndPhotosCell *)cell;
        [tCell configCell:self.photos];
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [(LTBaseTableViewCell *)cell ConfigCell:[UIImage imageNamed:@"task_activity_icon_update_deadline"] andTitle:@"谁可以看" andaccessoryText:nil];
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return [LTUploadTextAndPhotosCell cellHeight:self.photos];
    }
    
    return [LTBaseTableViewCell CellHeight];
}

#pragma mark - 导航栏按钮

- (void)cancleUpload{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AddPhotoDelegae
-(void)addPhotoOnClick{
    UIAlertController *uploadAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [uploadAlert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [uploadAlert addAction:[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [uploadAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"取消");
    }]];
    
    [self presentViewController:uploadAlert animated:YES completion:nil];
}

@end
