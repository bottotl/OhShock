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
#import "YYPhotoGroupView.h"
#import <Foundation/Foundation.h>
#import "UIImageView+WebCache.h"

@interface LTPostImagesView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, assign) NSUInteger                 picNum;    ///< 将要展示多少张图片

@property (nonatomic, assign) CGFloat                    itemSpace; ///< 图片间距

@property (nonatomic, assign) BOOL                       needBig;   ///< 是否需要显示大图

@property (nonatomic, assign) NSUInteger                 limit;     ///< 图片最多数量

@property (nonatomic, strong) RACSignal                  *imageTapSignal;///< 图片点击

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation LTPostImagesView
@synthesize photos = _photos;
#pragma mark - init
-(void)configViewWithPicNum:(NSUInteger)picNum needBig:(BOOL)needBig itemSpace:(CGFloat)itemSpace  limit:(NSUInteger )limit{
    self.picNum = picNum;
    self.needBig = needBig;
    self.itemSpace = itemSpace;
    self.limit = limit;
}

-(instancetype)init{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self p_initial];
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
    _collectionView.hidden = YES;
    [_collectionView registerClass:[LTPostImageCollectionViewCell class] forCellWithReuseIdentifier:LTPostImageCollectionCellIdentifier];
    [self addSubview:_collectionView];
    
}
#pragma mark - layout
- (void)layoutSubviews{
    [super layoutSubviews];
    NSInteger count = MIN(self.picNum, self.limit);
    CGFloat picWidth = ( self.width - 2 * self.itemSpace ) / 3;
    if ((self.needBig && count == 1) || count == 4 || count == 2) {
        picWidth = (self.width - self.itemSpace ) / 2;
    } else if (count == 1 && !self.needBig){
        picWidth = self.width;
    }
    if (self.picNum == 1 && self.needBig) {
        self.layout.itemSize = CGSizeMake(self.height, self.height);
    } else {
        self.layout.itemSize = CGSizeMake(picWidth, picWidth);
    }
    if (self.layout.itemSize.height > 0) {
        self.collectionView.frame = self.bounds;
    }
    
}
#pragma mark - sizeToFit
- (CGSize)sizeThatFits:(CGSize)size{
    if (size.width == 0) return size;
    NSInteger count = MIN(self.picNum, self.limit);
    CGFloat picWidth = ( self.width - 2 * self.itemSpace ) / 3;
    if (( self.needBig && count == 1 ) || count == 4) {
        size.width = self.itemSpace + 2 * picWidth;
        size.height = size.width;
    } else if (count < 3) {
        size.height = picWidth;
        size.width = count * (picWidth + self.itemSpace) - self.itemSpace;
    } else {
        size.height = [[self class] heightWithSuggestThreePicWidth:size.width andPicCount:self.picNum andBigPic:self.needBig andItemSpace:6 withLimit:self.limit];
    }
    return size;
}

#pragma mark - collectionView  delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.picNum;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LTPostImageCollectionViewCell *p_cell = [collectionView dequeueReusableCellWithReuseIdentifier:LTPostImageCollectionCellIdentifier forIndexPath:indexPath];
    if (self.photos.count > indexPath.row) {
        [p_cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.photos[[NSString stringWithFormat:@"%d",(int)indexPath.row]]]];
    }
    return p_cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    LTPostImageCollectionViewCell *p_cell = (LTPostImageCollectionViewCell *)cell;
//    if (self.photos.count > indexPath.row) {
//        [p_cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.photos[[NSString stringWithFormat:@"%d",(int)indexPath.row]]]];
//    }
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    LTPostImageCollectionViewCell *cell = (LTPostImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    LTPostImageModel *pic = self.data[indexPath.row];
//    [cell configCellWithImageUrl:pic.smallUrlString];
//    
//    NSMutableArray *items = @[].mutableCopy;
//    NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:0];
//    for (NSUInteger i = 0 ; i < self.limit && i < self.data.count; i++) {
//        LTPostImageCollectionViewCell *cell = (LTPostImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:index];
//        LTPostImageModel *pic = self.data[index.row];
//        [cell configCellWithImageUrl:pic.smallUrlString];
//        
//        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
//        item.thumbView = cell.imageView;
//        item.largeImageURL = [NSURL URLWithString:((LTPostImageModel *)self.data[index.row]).bigUrlString];
//        item.largeImageSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
//        [items addObject:item];
//        index = [NSIndexPath indexPathForRow:(index.row + 1) inSection:0];;
//    }
//    UINavigationController * viewController = [self theNavi];
//
//    NSLog(@"%@",[NSValue valueWithCGRect:[self convertRect:cell.frame toView:viewController.view]]) ;
//    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
//    [v presentFromView:self andFromItemIndex:indexPath.row andCellView:cell toContainer:viewController.view animated:YES completion:nil];

}



- (UINavigationController *)theNavi{
    return (UINavigationController *)((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController;
}

#pragma mark - property

- (void)setItemSpace:(CGFloat)itemSpace{
    _itemSpace = itemSpace;
    self.layout.minimumLineSpacing = itemSpace;
    self.layout.minimumInteritemSpacing = itemSpace;
}
-(NSMutableDictionary *)photos{
    if (!_photos) {
        _photos = @{}.mutableCopy;
    }
    return _photos;
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
