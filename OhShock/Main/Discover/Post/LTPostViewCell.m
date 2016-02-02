//
//  LTPostCell.m
//  OhShock
//
//  Created by Lintao.Yu on 16/1/3.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTPostViewCell.h"

@interface LTPostViewCell ()
@end

@implementation LTPostViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.loadedData = NO;
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.loadedData) {
        self.postView.frame = self.bounds;
    }
    
}

#pragma mark - property
-(LTPostView *)postView{
    if (!_postView) {
        _postView = [LTPostView new];
        _postView.frame = CGRectZero;
        [self.contentView addSubview:_postView];
    }
    return _postView;
}
-(void)prepareForReuse{
    [super prepareForReuse];
    self.loadedData = NO;
    self.postView.profileView.avatarUrlString = nil;
    self.postView.contentView.content = nil;
    self.postView.imagesView.thumbPhotos = nil;
}


@end
