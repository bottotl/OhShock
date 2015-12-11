//
//  LTDiscoverCell.m
//  OhShock
//
//  Created by Lintao.Yu on 12/8/15.
//  Copyright © 2015 Lintao Yu. All rights reserved.
//

#import "LTDiscoverCell.h"
#import "UIView+Layout.h"
#import "UIColor+expanded.h"

@interface LTDiscoverCell()

@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) UILabel *showTitleLabel;

@end

@implementation LTDiscoverCell
#pragma mark - init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.showImageView = [UIImageView new];
        [self addSubview:self.showImageView];
        
        self.showTitleLabel = [UILabel new];
        [self.showTitleLabel sizeToFit];
        
        self.showTitleLabel.font = [UIFont systemFontOfSize:12];
        self.showTitleLabel.textColor = [UIColor colorWithHexString:@"a8a8aa"];
        [self addSubview:self.showTitleLabel];
    }
    return self;
}

#pragma mark - property
-(void)setWithImage:(UIImage *)image title:(NSString *)title{
    if (self.showImageView) {
        self.showImageView.image = image;
    }
    if (self.showTitleLabel) {
        self.showTitleLabel.text = title;
    }
}

- (void)setShowImage:(UIImage *)showImage{
    if (self.showImageView) {
        self.showImageView.image = showImage;
    }
}

-(void)setShowTitle:(NSString *)showTitle{
    if (self.showTitleLabel) {
        self.showTitleLabel.text = showTitle;
    }
}

-(UIImage *)showImage{
    return self.showImageView.image;
}

-(NSString *)showTitle{
    return self.showTitleLabel.text;
}


#pragma mark - layout

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.showImageView.size = CGSizeMake(30, 30);
    self.showImageView.left = self.bounds.origin.x + 20;
    self.showImageView.centerY = self.bounds.size.height/2;
    
    [self.showTitleLabel sizeToFit];
    self.showTitleLabel.left = self.showImageView.right + 5;
    self.showTitleLabel.centerY = self.bounds.size.height/2;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
