//
//  LTGroupViewController.m
//  OhShock
//
//  Created by Lintao.Yu on 12/7/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTGroupViewController.h"
#import "UIView+Layout.h"
#import "LTGroupCell.h"
#import "XHPopMenu.h"
#import "LTGroupMessageViewController.h"
#import "LTGroupInfoViewController.h"
#import "CreateGroupViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "LTModelGroup.h"
#import "LTGroupService.h"
#import "LTSearchGroupViewController.h"
#import "CLSearchResultViewController.h"
#import "Header.h"


#import "CLChatRoomVC.h"

@interface LTGroupViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate>

@property (nonatomic, strong) UISearchController *mySearchController;

@end

@implementation LTGroupViewController{
    LTGroupService *groupService;
    
    UIButton *leftButton;
    UIButton *rightButton;
    UITableView *mainTableView;
    XHPopMenu *popMenu;
    
    //群组数据
    NSMutableArray *groupArray;
    CLSearchResultViewController *searchResult;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"privatemessage_normal"]
                           forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(gotoMessage)forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 35, 28);
    
    UIBarButtonItem *lMenuButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = lMenuButton;
    
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"moreBtn_Nav"]
                      forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(showMenuOnView:)forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 30, 20);
    
    UIBarButtonItem *rMenuButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rMenuButton;
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStyleGrouped];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:mainTableView];
    
    searchResult = [[CLSearchResultViewController alloc]init];
    self.mySearchController = [[UISearchController alloc] initWithSearchResultsController:searchResult];
    _mySearchController.searchResultsUpdater = self;
    _mySearchController.delegate = self;
//    _mySearchController.dimsBackgroundDuringPresentation = NO;
//    _mySearchController.hidesNavigationBarDuringPresentation = NO;
    _mySearchController.searchBar.frame = CGRectMake(0, 64, 0, 44.0);
    [_mySearchController.searchBar sizeToFit];
    mainTableView.tableHeaderView = self.mySearchController.searchBar;
    
    //有新消息时候加上小红点，先放在这边
    UIView *red = [[UIView alloc] initWithFrame:CGRectMake(30, 0, 10, 10)];
    red.layer.masksToBounds = YES;
    red.layer.cornerRadius = 5;
    red.backgroundColor = [UIColor redColor];
    [leftButton addSubview:red];
    
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshGroup) name:RefreshNotification object:nil];
    
    //初始化数据
    groupArray = [NSMutableArray array];
    groupService = [[LTGroupService alloc]init];
    [self refreshGroup];
}

- (void)viewWillAppear:(BOOL)animated{
    self.title = @"群组";
}

//刷新群组
- (void)refreshGroup{
    [groupService getGroupOfUser:[AVUser currentUser] andCallback:^(BOOL succeeded, NSError *error, NSArray *array) {
        if (succeeded) {
            groupArray = [array mutableCopy];
            [mainTableView reloadData];
        }
    }];
}

#pragma mark tableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return groupArray.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.imageView.image = [UIImage imageNamed:@"found_dynamic"];
        cell.textLabel.text = @"群组动态";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if (indexPath.section == 1){
        LTGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell"];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"LTGroupCell" bundle:nil] forCellReuseIdentifier:@"groupCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell"];
        }
        [cell setCellWithGroup:groupArray[indexPath.row]];
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"我的群";
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 12;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        //点击群组动态
        
    }else{
//        //点击进入群详情
//        LTGroupInfoViewController *controller = [[LTGroupInfoViewController alloc]init];
//        controller.group = groupArray[indexPath.row];
//        controller.groupName = [groupArray[indexPath.row] objectForKey:@"groupName"];
//        [self.navigationController pushViewController:controller animated:YES];
        //测试
        //点击进入群聊界面，先放这
  
        WEAKSELF
        NSMutableArray *memberIds = [NSMutableArray array];
        LTModelGroup *group = groupArray[indexPath.row];
        AVQuery *query = [LTModelGroup query];
        [query whereKey:@"groupName" equalTo:group.groupName];
        [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            NSArray *members = [object objectForKey:@"groupMembers"];
            for (int i = 0; i < members.count; i++) {
//                if (![members[i] isEqual:[AVUser currentUser]]) {
                    [memberIds addObject:[members[i] objectForKey:@"objectId"]];
//                }
            }
//            [memberIds addObject:[CDChatManager manager].selfId];
            [[CDChatManager manager] fetchConvWithMembers:memberIds callback: ^(AVIMConversation *conversation, NSError *error) {
                if (error) {
                    DLog(@"%@", error);
                }
                else {
                    CDChatRoomVC *chatRoomVC = [[CDChatRoomVC alloc] initWithConv:conversation];
                    chatRoomVC.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:chatRoomVC animated:YES];
                }
            }];
        }];
    }
}


#pragma mark UISearchController Delegate Methods
//搜索聊天记录 实现：：：：
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
//    mainTableView.top = 64;
//    NSString *filterString = searchController.searchBar.text;
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@", filterString];
//    
//    self.visableArray = [NSMutableArray arrayWithArray:[self.dataSourceArray filteredArrayUsingPredicate:predicate]];
//    
//    [self.myTableView reloadData];
}


//在这两个方法中改变tableview frame是因为点击searchbar 时会出现把searchbar弹出顶部的bug，暂时没找到好的解决方法
-(void)willPresentSearchController:(UISearchController *)searchController{
    [UIView animateWithDuration:0.2 animations:^{
        mainTableView.top = 64;
    }];
}

-(void)willDismissSearchController:(UISearchController *)searchController{
     mainTableView.top = 0;
}

#pragma mark 导航栏点击事件
//点击消息按钮，跳到消息页面
- (void)gotoMessage{
    LTGroupMessageViewController *controller = [[LTGroupMessageViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

//点击更多按钮，弹出菜单视图
- (void)showMenuOnView:(UIBarButtonItem *)buttonItem {
    [self.popMenu showMenuOnView:self.navigationController.view atPoint:CGPointZero];
}
#pragma mark config popMenu
- (XHPopMenu *)popMenu {
    if (!popMenu) {
        NSMutableArray *popMenuItems = [[NSMutableArray alloc] initWithCapacity:3];
        for (int i = 0; i < 2; i ++) {
            NSString *imageName;
            NSString *title;
            switch (i) {
                case 0: {
                    imageName = @"contacts_add_newmessage";
                    title = @"创建群组";
                    break;
                }
                case 1: {
                    imageName = @"contacts_add_friend";
                    title = @"搜索群组";
                    break;
                }
                default:
                    break;
            }
            XHPopMenuItem *popMenuItem = [[XHPopMenuItem alloc] initWithImage:[UIImage imageNamed:imageName] title:title];
            [popMenuItems addObject:popMenuItem];
        }
        
        __weak __typeof(self) weakSelf = self;
        popMenu = [[XHPopMenu alloc] initWithMenus:popMenuItems];
        popMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem *popMenuItems) {
            if (index == 0) {
                printf("创建群组 index 1\n");
                CreateGroupViewController *controller = [[CreateGroupViewController alloc]init];
                [weakSelf.navigationController pushViewController:controller animated:YES];
            }else if (index == 1 ) {
                printf("搜索群组 index 0\n");
                LTSearchGroupViewController *controller = [[LTSearchGroupViewController alloc]init];
                [weakSelf.navigationController pushViewController:controller animated:YES];
            }
        };
    }
    return popMenu;
}

@end
