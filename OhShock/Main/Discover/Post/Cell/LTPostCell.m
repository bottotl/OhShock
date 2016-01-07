//
//  LTPostCell.m
//  OhShock
//
//  Created by Lintao.Yu on 16/1/3.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTPostCell.h"
#import "UIView+Layout.h"
#import "LTPostLayout.h"

static CGFloat const LTPostImagePadding = 5;
static CGFloat const LTPsotContentPadding = 5;

@interface LTPostCell ()

@property (nonatomic, assign) BOOL isNeedShowImages;

@end

@implementation LTPostCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    for (UIView *view in self.subviews) {
        if([view isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)view).delaysContentTouches = NO; // Remove touch delay for iOS 7
            break;
        }
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    _profileView = [LTPostProfileView new];
    [self.contentView addSubview:_profileView];
    
    _ltContentView = [LTPostContentView new];
    [self.contentView addSubview:_ltContentView];
    
    _imagesView = [LTPostImagesView new];
    [self.contentView addSubview:_imagesView];
//    if (self.isNeedShowImages) {
//        
//    }
//    
    
    return self;
}
-(void)layoutSubviews{
    
    self.profileView.left = 0;
    self.profileView.top = 0;
    
    self.ltContentView.left = LTPsotContentPadding;
    self.ltContentView.top = self.profileView.bottom;
    
    self.imagesView.top = self.ltContentView.bottom;
    self.imagesView.centerX = self.contentView.centerX;
    [super layoutSubviews];
}

-(void)setLayout:(LTPostLayout *)layout{
    _layout = layout;
    [self.profileView setAvatatImageWithUrlString:@"http://ww2.sinaimg.cn/mw690/6b5f103fgw1ezootytakgj20p00p048x.jpg"];
    [self.profileView setName:@"jft0m"];
    [self.profileView setNeedsLayout];
    
    [self.ltContentView setContent:[[NSAttributedString alloc]initWithString:@"回复@煒傑_湯:我今天刚好看到一句话：“iPad Pro 不是给现在的笔记本电脑用户的。这是给触屏时代用户的未来笔记本电脑”。iOS 在迈入第9代时终于长大了，分屏操作让它能做更多以前不能做的事，你也可以找到海量适合触屏操作的软件。如果你的工作用到触屏－我建议你尝试 iPad Pro 而不是 MacBook Pro"]];
    [self.ltContentView setNeedsLayout];
    
    self.imagesView.images = @[@"http://ww2.sinaimg.cn/mw690/6b5f103fgw1ezootytakgj20p00p048x.jpg"
                           ,@"http://ww2.sinaimg.cn/mw690/6b5f103fgw1ezootytakgj20p00p048x.jpg"
                           ,@"http://ww2.sinaimg.cn/mw690/6b5f103fgw1ezootytakgj20p00p048x.jpg"
                           ].copy;
    [self.imagesView setNeedsLayout];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}

@end
