//
//  SetGroupLabelsViewController.m
//  OhShock
//
//  Created by chenlong on 16/1/11.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "SetGroupLabelsViewController.h"
#import "Header.h"
#import "GroupLabelCell.h"

@interface SetGroupLabelsViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@end

@implementation SetGroupLabelsViewController{
    UITableView *mainTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addLabel)];
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStylePlain];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:mainTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    self.title = @"添加标签";
}

- (void)viewWillDisappear:(BOOL)animated{
    if (_doneBlock) {
        _doneBlock(_labelArray);
    }
    [super viewWillDisappear:animated];
}

- (void)addLabel{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"添加标签" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

#pragma mark UITableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _labelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"labelCell"];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"GroupLabelCell" bundle:nil] forCellReuseIdentifier:@"labelCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"labelCell"];
    }
    cell.labelName.text = _labelArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_labelArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [mainTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma mark UIAletView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        [_labelArray addObject:textField.text];
        [mainTableView reloadData];
    }
}

@end