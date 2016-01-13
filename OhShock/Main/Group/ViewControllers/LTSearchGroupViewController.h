//
//  LTSearchGroupViewController.h
//  OhShock
//
//  Created by chenlong on 16/1/13.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTSearchGroupViewController : UITableViewController<UISearchBarDelegate>
@property (nonatomic, strong) NSArray *dataSource;
@end
