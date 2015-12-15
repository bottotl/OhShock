//
//  UISearchBar+RACSignalSupport.h
//  OhShock
//
//  Created by Lintao.Yu on 15/12/15.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACDelegateProxy;
@class RACSignal;

@interface UISearchBar (RACSignalSupport)<UISearchBarDelegate>

- (RACSignal *)rac_textSignal;

@end
