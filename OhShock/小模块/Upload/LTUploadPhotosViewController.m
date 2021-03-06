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
#import "QBImagePickerController.h"
#import "LTUploadService.h"
#import "UIView+Layout.h"

@interface LTUploadPhotosViewController ()<UITableViewDataSource, UITableViewDelegate, LTUploadTextAndPhotosViewDelegae, QBImagePickerControllerDelegate, YYTextViewDelegate>

@property (nonatomic, strong) QBImagePickerController *imagePickerController;

@property (nonatomic, strong) UITableView *tableView;

/// 展示的数据
@property (nonatomic, strong) NSMutableArray <UIImage *> *photos;

/// 原始数据（可以通过这个属性获得原始数据）
@property (nonatomic, strong) NSMutableArray <PHAsset *> *selectedAsset;

///// 主内容文本
//@property (nonatomic, copy) NSString *content;

/// 主内容富文本
@property (nonatomic, strong) NSAttributedString *attributedContent;

/// 上传服务类
@property (nonatomic, strong) LTUploadService *service;

@end

@implementation LTUploadPhotosViewController

@synthesize selectedAsset = _selectedAsset;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.frame = self.view.bounds;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[LTUploadTextAndPhotosCell class] forCellReuseIdentifier:LTUploadTextAndPhotosCellIdentifier];
    [_tableView registerClass:[LTBaseTableViewCell class] forCellReuseIdentifier:LTBaseTableViewCellIdentifier];
    
    /// 导航栏按钮
    UIBarButtonItem *cancleButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleUpload)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneUpload)];
    
    self.navigationItem.leftBarButtonItem = cancleButton;
    self.navigationItem.rightBarButtonItem = doneButton;

}

#pragma mark - property
-(QBImagePickerController *)imagePickerController{
    if (!_imagePickerController) {
        _imagePickerController = [QBImagePickerController new];
        _imagePickerController.mediaType = QBImagePickerMediaTypeImage;
        _imagePickerController.delegate = self;
        _imagePickerController.allowsMultipleSelection = YES;
        _imagePickerController.maximumNumberOfSelection = 9;
    }
    return _imagePickerController;
}
-(LTUploadService *)service{
    if (!_service) {
        _service = [LTUploadService new];
    }
    return _service;
}
-(NSMutableArray<UIImage *> *)photos{
    if (!_photos) {
        _photos = @[].mutableCopy;
    }
    return _photos;
}
-(NSMutableArray *)selectedAsset{
    if (!_selectedAsset){
        _selectedAsset = @[].mutableCopy;
    }
    return _selectedAsset;
}

-(void)setSelectedAsset:(NSMutableArray *)selectedAsset{
    _selectedAsset = selectedAsset;
    [self updatePhotos];
    
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
        cell.richView.delegate = self;
        cell.richView.textView.delegate = self;
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
        return [LTUploadTextAndPhotosCell cellHeightWithPhotoCount:self.selectedAsset.count andWidth:self.view.width];
    }
    
    return [LTBaseTableViewCell CellHeight];
}

#pragma mark - 导航栏按钮
/// 取消按钮响应事件
- (void)cancleUpload{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

/// 上传按钮响应事件
- (void)doneUpload{
    [self.service uploadPost:self.selectedAsset andContent:self.attributedContent andBlock:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"成功上传 post");
        }else{
            NSLog(@"error: %@",error);
        }
        
    }];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - delegate
#pragma mark AddPhotoDelegae
-(void)addPhotoOnClick{
    UIAlertController *uploadAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [uploadAlert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    @weakify(self);
    [uploadAlert addAction:[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        @strongify(self);
        [self.imagePickerController.selectedAssets removeAllObjects];
        [self.imagePickerController.selectedAssets addObjectsFromArray:self.selectedAsset];
        [self presentViewController:self.imagePickerController animated:YES completion:NULL];
    }]];
    [uploadAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"取消");
    }]];
    
    [self presentViewController:uploadAlert animated:YES completion:nil];
}

#pragma mark QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray <PHAsset *>*)assets{
    [self.selectedAsset removeAllObjects];
    self.selectedAsset = assets.mutableCopy;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView;{
    self.attributedContent = textView.attributedText;
}


#pragma mark - 
#pragma mark 更新图片
- (void)updatePhotos{
    [self.photos removeAllObjects];
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
    option.synchronous = YES;// 同步读取
    option.version = PHImageRequestOptionsVersionCurrent;
    for (int i = 0;i < self.selectedAsset.count; i++){
        @weakify(self);
        [[PHImageManager defaultManager]requestImageForAsset:self.selectedAsset[i] targetSize:CGSizeMake(40, 40) contentMode:PHImageContentModeDefault options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) {
                @strongify(self);
                [self.photos addObject:result];
                if (i == self.selectedAsset.count - 1 ) {
                    @weakify(self);
                    dispatch_async(dispatch_get_main_queue(), ^{
                         @strongify(self);
                        [self.tableView reloadData];
                    });
                }
            }
            
        }];
    }
}

@end
