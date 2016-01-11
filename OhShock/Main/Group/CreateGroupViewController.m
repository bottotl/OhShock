//
//  CreateGroupViewController.m
//  OhShock
//
//  Created by chenlong on 16/1/9.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "Header.h"
#import "SKTagView.h"
#import "HexColors.h"
#import "TagsTableCell.h"
#import "InputGroupNameViewController.h"
#import "PickView.h"
#import "SelectAddressViewController.h"
#import "SetGroupLabelsViewController.h"
#import "GroupIntroductionViewController.h"

static NSString *const kTagsTableCellReuseIdentifier = @"TagsTableCell";

@interface CreateGroupViewController ()<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, PickDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSArray *colorPool;//标签颜色

@property (nonatomic, strong) UIPickerView *myPicker;
@property (nonatomic, strong) PickView *pickerBgView;//自定义带pickView的视图
@property (nonatomic, strong) UIView *maskView;//阴影层
@property (nonatomic, strong) NSArray *groupStyleArray;

@end

@implementation CreateGroupViewController{
    UITableView *mainTableView;
    NSString *groupName;//群名
    NSString *groupStyle;//群类型
    NSString *groupAddress;//群地址
    NSMutableArray *groupLabels;//群标签
    NSString *groupIntroduction;//群介绍
    UIImage *groupImage;//群图片
    
    NSInteger selectIndex;//pickerView选中下标
}

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
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(next)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStyleGrouped];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:mainTableView];
    
    //    self.tableView.backgroundColor = [UIColor redColor];
    [mainTableView registerNib:[UINib nibWithNibName:@"TagsTableCell" bundle:nil] forCellReuseIdentifier:kTagsTableCellReuseIdentifier];
    
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PickView" owner:nil options:nil];
    for(id currentObject in topLevelObjects)
    {
        if([currentObject isKindOfClass:[PickView class]])
        {
            self.pickerBgView = (PickView *)currentObject;
            break;
        }
    }
    
    self.maskView = [[UIView alloc] initWithFrame:kScreen_Frame];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
    
    self.pickerBgView.width = kScreen_Width;

    
    self.pickerBgView.delegate = self;
    self.myPicker = self.pickerBgView.myPicker;
    self.myPicker.dataSource = self;
    self.myPicker.delegate = self;
    
    self.groupStyleArray = @[@"私密群", @"兴趣群", @"学术群", @"家庭群", @"羞羞群"];
    groupLabels = [NSMutableArray array];
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.title = @"创建群组";
}

#pragma mark - button click
- (void)onAddPicClick{
    UIActionSheet* sheet = [[UIActionSheet alloc] init];
    sheet.delegate = self;
    [sheet addButtonWithTitle:@"拍照"];
    [sheet addButtonWithTitle:@"从相册选取"];
    [sheet addButtonWithTitle:@"取消"];
    
    sheet.cancelButtonIndex = 2;
    [sheet showInView:self.view];
}

-(void)next{
    
}

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _groupStyleArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.groupStyleArray objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 100;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectIndex = row;
}

- (void)hideMyPicker {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.pickerBgView.top = self.view.height;
        
        
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}


-(void)cancel{
    [self hideMyPicker];
}

-(void)ensure{
    groupStyle = _groupStyleArray[selectIndex];
    [mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self hideMyPicker];
}


#pragma mark UITableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSString* cellIdentifier1 = @"cell1";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
                UILabel* l = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 100, 30)];
                l.font = [UIFont systemFontOfSize:15];
                l.text = @"标题:";
                [cell.contentView addSubview:l];
                
                UILabel *groupNameLabll = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - 220, 7, 200, 30)];
                groupNameLabll.font = [UIFont systemFontOfSize:14];
                groupNameLabll.textAlignment = NSTextAlignmentRight;
                groupNameLabll.textColor = [UIColor lightGrayColor];
                if (groupName) {
                    groupNameLabll.text = groupName;
                }else{
                    groupNameLabll.text = @"输入群名";
                }
                [cell.contentView addSubview:groupNameLabll];
            }
            return cell;
        }
        if (indexPath.row == 1) {
            NSString* cellIdentifier2 = @"cell2";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
                UILabel* l = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 100, 30)];
                l.font = [UIFont systemFontOfSize:15];
                l.text = @"群类型:";
                [cell.contentView addSubview:l];
                
                UILabel *groupStyleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - 220, 7, 200, 30)];
                groupStyleLabel.font = [UIFont systemFontOfSize:14];
                groupStyleLabel.textAlignment = NSTextAlignmentRight;
                groupStyleLabel.textColor = [UIColor lightGrayColor];
                if (groupStyle) {
                    groupStyleLabel.text = groupStyle;
                }else{
                    groupStyleLabel.text = @"选择群类型";
                }
                [cell.contentView addSubview:groupStyleLabel];
            }
            return cell;
        }
        if (indexPath.row == 2) {
            NSString* cellIdentifier3 = @"cell3";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
                UILabel* l = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 100, 30)];
                l.font = [UIFont systemFontOfSize:15];
                l.text = @"群地点:";
                [cell.contentView addSubview:l];
                
                UILabel *groupAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - 220, 7, 200, 30)];
                groupAddressLabel.font = [UIFont systemFontOfSize:14];
                groupAddressLabel.textAlignment = NSTextAlignmentRight;
                groupAddressLabel.textColor = [UIColor lightGrayColor];
                if (groupAddress) {
                    groupAddressLabel.text = groupAddress;
                }else{
                    groupAddressLabel.text = @"选择群地址";
                }
               
                [cell.contentView addSubview:groupAddressLabel];
            }
            return cell;
        }
    }
    
    if (indexPath.section == 1) {
        TagsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kTagsTableCellReuseIdentifier forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }
    
    if (indexPath.section == 2) {
        NSString* cellIdentifier5 = @"cell5";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier5];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier5];
            UILabel* l = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 100, 30)];
            l.font = [UIFont systemFontOfSize:15];
            l.text = @"群介绍:";
            [cell.contentView addSubview:l];
            
            UILabel *groupIntroductionLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 20, kScreen_Width - 80, 60)];
            groupIntroductionLabel.textColor = [UIColor lightGrayColor];
            groupIntroductionLabel.font = [UIFont systemFontOfSize:13];
            if (groupIntroduction) {
                 groupIntroductionLabel.text = groupIntroduction;
            }else{
                 groupIntroductionLabel.text = @"  输入群介绍...";
            }
            groupIntroductionLabel.numberOfLines = 0;
            //            groupIntroduction.backgroundColor = [UIColor greenColor];
            [cell.contentView addSubview:groupIntroductionLabel];
            cell.height = 90;
        }
        return cell;
    }
    
    if (indexPath.section == 3) {
        NSString* cellIdentifier6 = @"cell6";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier6];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier6];
            UILabel* l = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 100, 30)];
            l.font = [UIFont systemFontOfSize:15];
            l.text = @"群图片:";
            [cell.contentView addSubview:l];
            
            UIImageView *groupImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width / 2 - 50, 10, 100, 100)];
            if (groupImage) {
                groupImageView.image = groupImage;
            }else{
                groupImageView.image = [UIImage imageNamed:@"AddGroupMemberBtnHL"];
            }
            groupImageView.userInteractionEnabled = YES;
            [groupImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAddPicClick)]];
            [cell.contentView addSubview:groupImageView];
            cell.height = 120;
        }
        return cell;
    }


    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        TagsTableCell *cell = nil;
        if (!cell)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kTagsTableCellReuseIdentifier];
        }
        
        [self configureCell:cell atIndexPath:indexPath];
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    }
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)configureCell:(TagsTableCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //标签颜色
    self.colorPool = @[@"#7ecef4", @"#84ccc9", @"#88abda",@"#7dc1dd",@"#b6b8de"];
    cell.tagView.preferredMaxLayoutWidth = kScreen_Width;
    cell.tagView.padding    = UIEdgeInsetsMake(12, 12, 12, 12);
    cell.tagView.insets    = 15;
    cell.tagView.lineSpace = 10;
    
    [cell.tagView removeAllTags];
    if (!groupLabels.count) {
        //Add Tags
        [@[@"添加群标签..."] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             SKTag *tag = [SKTag tagWithText:obj];
             tag.textColor = [UIColor whiteColor];
             tag.fontSize = 15;
             tag.padding = UIEdgeInsetsMake(5, 10, 5, 10);
             tag.bgColor = [UIColor colorWithHexString:self.colorPool[arc4random() % self.colorPool.count] alpha:1];
             tag.cornerRadius = 5;
             tag.enable = NO;
             
             [cell.tagView addTag:tag];
         }];

    }else{
        //Add Tags
        [groupLabels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             SKTag *tag = [SKTag tagWithText:obj];
             tag.textColor = [UIColor whiteColor];
             tag.fontSize = 15;
             tag.padding = UIEdgeInsetsMake(5, 10, 5, 10);
             tag.bgColor = [UIColor colorWithHexString:self.colorPool[arc4random() % self.colorPool.count] alpha:1];
             tag.cornerRadius = 5;
             tag.enable = NO;
             
             [cell.tagView addTag:tag];
         }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //输入群名
            InputGroupNameViewController *controller = [[InputGroupNameViewController alloc]init];
            controller.doneBlock = ^(NSString *str){
                groupName = str;
                [mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:controller animated:YES];
        }
        
        if (indexPath.row == 1) {
            //选择群类型
            [self.view addSubview:self.maskView];
            [self.view addSubview:self.pickerBgView];
            self.maskView.alpha = 0;
            self.pickerBgView.top = self.view.height;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.maskView.alpha = 0.4;
                self.pickerBgView.bottom = self.view.height;
            }];
        }
        
        if (indexPath.row == 2) {
            //选择群地点
            SelectAddressViewController *controller = [[SelectAddressViewController alloc]init];
            controller.doneBlock = ^(NSString *str){
                groupAddress = str;
                [mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            //设置群标签
            SetGroupLabelsViewController *controller = [[SetGroupLabelsViewController alloc]init];
            controller.labelArray = groupLabels;
            controller.doneBlock = ^(NSMutableArray *array){
                groupLabels = array;
                [mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else if (indexPath.section == 2){
        //群介绍
        GroupIntroductionViewController *controller = [[GroupIntroductionViewController alloc]init];
        controller.introduction = groupIntroduction;
        controller.doneBlock = ^(NSString *str){
            groupIntroduction = str;
            [mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.section == 3){
        //群头像
        
    }
}

#pragma mark - actionSheet
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subView in actionSheet.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subView;
            [button setTitleColor:RGBCOLOR(11, 176, 16)
                         forState:UIControlStateNormal];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self snapImage];
    }
    else if (buttonIndex == 1) {
        [self pickImage];
    }
}

#pragma mark - 照片上传
//拍照
- (void)snapImage
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    ipc.allowsEditing = NO;
    [self presentViewController:ipc animated:YES completion:nil];
}

//从相册里找
- (void)pickImage
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    ipc.allowsEditing = NO;
    [self presentViewController:ipc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    groupImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [mainTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}
@end
