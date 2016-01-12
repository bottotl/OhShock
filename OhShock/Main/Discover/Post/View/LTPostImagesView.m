//
//  LTPostImagesView.m
//  OhShock
//
//  Created by Lintao.Yu on 1/6/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import "LTPostImagesView.h"
#import "LTPostImageCollectionViewCell.h"
#import "UIView+Layout.h"
#import "LTPostImageModel.h"
#import "YYPhotoGroupView.h"
#import <Foundation/Foundation.h>

@interface LTPostImagesView ()<UICollectionViewDataSource>



@property (nonatomic, strong) UICollectionViewFlowLayout *layout;


@end

@implementation LTPostImagesView
@synthesize picItems = _picItems;
#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self p_initial];
        [self reset];
    }
    return self;
}
/**
 *  初始化 Collection View
 */
- (void)p_initial{
    _layout = [UICollectionViewFlowLayout new];
    _collectionView  = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.scrollEnabled = NO;
    [_collectionView registerClass:[LTPostImageCollectionViewCell class] forCellWithReuseIdentifier:LTPostImageCollectionCellIdentifier];
    [self addSubview:_collectionView];
    
}
#pragma mark - layout
- (void)layoutSubviews{
    [super layoutSubviews];
    NSInteger count = MIN(self.data.count, self.limit);
    CGFloat picWidth = ( self.width - 2 * self.itemSpace ) / 3;
    if ((self.needBig && count == 1) || count == 4 || count == 2) {
        picWidth = (self.width - self.itemSpace ) / 2;
    } else if (count == 1 && !self.needBig){
        picWidth = self.width;
    }
    if (self.data.count == 1 && self.needBig) {
        self.layout.itemSize = CGSizeMake(self.height, self.height);
    } else {
        self.layout.itemSize = CGSizeMake(picWidth, picWidth);
    }
    self.collectionView.frame = self.bounds;
    
}
#pragma mark - sizeToFit
- (CGSize)sizeThatFits:(CGSize)size{
    if (size.width == 0) return size;
    NSInteger count = MIN(self.data.count, self.limit);
    CGFloat picWidth = ( self.width - 2 * self.itemSpace ) / 3;
    if (( self.needBig && count == 1 ) || count == 4) {
        size.width = self.itemSpace + 2 * picWidth;
        size.height = size.width;
    } else if (count < 3) {
        size.height = picWidth;
        size.width = count * (picWidth + self.itemSpace) - self.itemSpace;
    } else {
        size.height = [[self class] heightWithSuggestThreePicWidth:size.width andPicCount:self.data.count andBigPic:self.needBig andItemSpace:6 withLimit:self.limit];
    }
    return size;
}

- (void)reset{
    
    self.needBig = YES;
    self.data = nil;
}

#pragma mark - collectionView  delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LTPostImageCollectionViewCell *cell = (LTPostImageCollectionViewCell  *)[collectionView dequeueReusableCellWithReuseIdentifier:LTPostImageCollectionCellIdentifier forIndexPath:indexPath];
    LTPostImageModel *pic = self.data[indexPath.row];
    [cell configCellWithImageUrl:pic.smallUrlString];
//    if (self.limit < self.data.count && indexPath.row == self.limit - 1) {
//        cell.numberLabel.hidden = NO;
//        cell.numberLabel.text = [@(self.data.count) stringValue];
//    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *items = @[].mutableCopy;
//    NSLog(@"点击了图片");
    UINavigationController * viewController = [self theNavi];
    LTPostImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LTPostImageCollectionCellIdentifier forIndexPath:indexPath];
    NSLog(@"%@",[NSValue valueWithCGRect:[self convertRect:cell.frame toView:viewController.view]]) ;
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:self.picItems];
    [v presentFromImageView:self toContainer:viewController.view animated:YES completion:^{
        self.picItems = nil;
    }];
}



- (UINavigationController *)theNavi{
    return (UINavigationController *)((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController;
}

-(void)setPicItems:(NSArray *)picItems{
    _picItems = picItems;
}

- (NSArray *)picItems{
    NSMutableArray *items = @[].mutableCopy;
    if (!_picItems) {
        NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:0];
        for (NSUInteger i = 0 ; i < self.limit && i < self.data.count; i++) {
            LTPostImageCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:LTPostImageCollectionCellIdentifier forIndexPath:index];
            LTPostImageModel *pic = self.data[index.row];
            [cell configCellWithImageUrl:pic.smallUrlString];
            
            YYPhotoGroupItem *item = [YYPhotoGroupItem new];
            item.thumbView = cell.contentView;
            item.largeImageURL = [NSURL URLWithString:((LTPostImageModel *)self.data[index.row]).bigUrlString];
            item.largeImageSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
            [items addObject:item];
            index = [NSIndexPath indexPathForRow:(index.row + 1) inSection:0];;
        }

    }
    return items.copy;
    
}
#pragma mark - property
- (void)setData:(NSArray *)data{
    _data = data;
    [self.collectionView reloadData];
}

- (void)setItemSpace:(CGFloat)itemSpace{
    _itemSpace = itemSpace;
    self.layout.minimumLineSpacing = itemSpace;
    self.layout.minimumInteritemSpacing = itemSpace;
}

#pragma mark - 计算总高度
+ (CGFloat)heightWithSuggestThreePicWidth:(CGFloat)width andPicCount:(NSInteger)count andBigPic:(BOOL)bigpic andItemSpace:(CGFloat)space withLimit:(NSInteger)limit{
    count = MIN(limit, count);
    CGFloat picWidth = ( width - 2 * space ) / 3;
    if (!count || picWidth < 0) {
        return 0;
    } else if (count == 4 || (count == 1 && bigpic)) {
        return 2 * picWidth + space;
    } else {
        return ( picWidth + space ) * (( count + 2 ) / 3) - space;
    }
}

@end
