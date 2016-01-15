//
//  LTUploadTextAndPhotosView.m
//  OhShock
//
//  Created by lintao.yu on 16/1/14.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import "LTUploadTextAndPhotosView.h"
#import "LTUploadPhotoCollectionCell.h"
#import "LTUploadAddPhotoColloectionCell.h"
#import "UIView+Layout.h"

/// 距离屏幕左边距
static CGFloat const    PhotosLeftPadding = 5;
/// 图片间距
static CGFloat const    PhotosPadding     = 5;
/// 文本输入框的高度
static CGFloat const    TextViewHeight    = 120;
/// 每行最多多少张图片
static NSInteger const  MaxLineNum        = 4;
/// 输入文本的文字字体大小
static CGFloat textViewFontSize = 16.0;


@interface LTUploadTextAndPhotosView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectioneView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSArray *photos;

@end


@implementation LTUploadTextAndPhotosView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat with = [LTUploadTextAndPhotosView photoHeight];;
        layout.itemSize = CGSizeMake(with, with);
        _collectioneView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectioneView.scrollEnabled = NO;
        _collectioneView.backgroundColor = [UIColor clearColor];
        _collectioneView.delegate = self;
        _collectioneView.dataSource = self;
        [self addSubview:_collectioneView];
        
        [_collectioneView registerClass:[LTUploadPhotoCollectionCell class] forCellWithReuseIdentifier:LTUploadPhotoCollectionCellIdentifier];
        [_collectioneView registerClass:[LTUploadAddPhotoColloectionCell class] forCellWithReuseIdentifier:LTUploadAddPhotoCellIdentifier];
        
        _textView = [UITextView new];
        _textView.delegate = self.textViewDelegate;
        _textView.font = [UIFont systemFontOfSize:textViewFontSize];
        [self addSubview:_textView];
    }
    
    return self;
}
-(void)configView:(NSArray *)photos{
    self.photos = photos;
    [self.collectioneView reloadData];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _photos.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.photos.count) {
        LTUploadAddPhotoColloectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LTUploadAddPhotoCellIdentifier forIndexPath:indexPath];
        if([self.delegate respondsToSelector:@selector(addPhotoOnClick)]){
            [cell.addPhotoButton addTarget:self.delegate action:@selector(addPhotoOnClick) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return cell;
    }
    
    LTUploadPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LTUploadPhotoCollectionCellIdentifier forIndexPath:indexPath];
    return cell;
    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.photos.count) {
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row != self.photos.count){
        [(LTUploadPhotoCollectionCell *)cell configCellWith:self.photos[indexPath.row]];
    }
    
}

#pragma mark - layout 
-(void)layoutSubviews{
    [super layoutSubviews];
    self.textView.width = self.width - PhotosLeftPadding * 2;
    self.textView.height = TextViewHeight;
    self.textView.left = PhotosLeftPadding;
    self.textView.top = PhotosLeftPadding;
    
    self.collectioneView.width = self.textView.width;
    self.collectioneView.height = [[self class]collectionViewHeight:self.photos.count +1];
    self.collectioneView.left = PhotosLeftPadding;
    self.collectioneView.bottom = self.height;
}

#pragma mark - 计算高度
+(CGFloat)heightWithPhotos:(NSArray *)photos{
    CGFloat height = [[self class]collectionViewHeight:photos.count + 1];
    
    CGFloat offset = PhotosLeftPadding;
    height += TextViewHeight;
    height += offset * 2;
    
    return height;
}

+(CGFloat)photoHeight{
    return ([UIScreen mainScreen].bounds.size.width - 2 * PhotosLeftPadding - (MaxLineNum - 1) * PhotosPadding ) / MaxLineNum - 8;
}

+(CGFloat)collectionViewHeight:(NSInteger)photoCount{
    CGFloat photoHeight = [LTUploadTextAndPhotosView photoHeight];
    NSInteger lineNum = (photoCount-1) / MaxLineNum  + 1;
    return PhotosLeftPadding * 2 + photoHeight * lineNum + PhotosPadding * (lineNum - 1);
}

@end
