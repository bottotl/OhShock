//
//  LTAddTodoTextCell.m
//  OhShock
//
//  Created by Lintao.Yu on 15/12/24.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "LTAddTodoTextCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIView+Layout.h"
@interface LTAddTodoTextCell()
@property (nonatomic, strong) UITextView *textView;
@end
@implementation LTAddTodoTextCell

-(instancetype)init{
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LTAddTodoTextCellIdentifier];
    //self.userInteractionEnabled = NO;
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textView = [UITextView new];
        self.textView.font = [UIFont systemFontOfSize:25];
        self.textView.userInteractionEnabled = YES;
        
        [self.contentView addSubview:self.textView];
    }
    
    return self;
}

-(void)layoutSubviews{
    self.textView.width = self.contentView.width;
    self.textView.height = self.contentView.height;
    self.textView.left = 0;
    self.textView.top = 0;
    [super layoutSubviews];
}
-(RACSignal *)rac_textChangeSignal{
    return self.textView.rac_textSignal;
}

@end
