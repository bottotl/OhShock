//
//  LTPostCommentView.m
//  OhShock
//
//  Created by Lintao.Yu on 1/10/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import "LTPostCommentView.h"
#import "LTPostCommentCell.h"

@interface LTPostCommentView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LTPostCommentView
#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
    }
    return self;
}

#pragma mark - Layout
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect targetRect = self.bounds;
    targetRect.origin.y = [[self class] topSpace];
    self.tableView.frame = targetRect;
}

- (CGSize)sizeThatFits:(CGSize)size{
    size.height = [[self class]suggestHeightWithComments:self.comments andLimit:self.limit andFold:self.fold withWidth:size.width];
    return size;
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count =  self.fold?MIN(self.comments.count, self.limit):self.comments.count;
    if (self.limit < self.comments.count) count++;
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LTPostCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:LTPostCommentCellIdentifier forIndexPath:indexPath];
    [cell configCellWithAttributedString:self.comments[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LTPostCommentModel *model = self.comments[indexPath.row];
    return [LTPostCommentCell heightWithAttributedString:model.text andWidth:[UIScreen mainScreen].bounds.size.width];
}
#pragma mark - 计算高度
+ (CGFloat)suggestHeightWithComments:(NSArray *)comments andLimit:(NSInteger)limit andFold:(BOOL)fold withWidth:(CGFloat)width{
    CGFloat height = 0;
    if (fold) {
        for (NSInteger index = 0; index != MIN(limit, comments.count); index++) {
            LTModelPostComment *comment = comments[index];
            LTPostCommentModel *model = [[LTPostCommentModel alloc] initWithComment:comment];
            height += [LTPostCommentCell heightWithAttributedString:model.text andWidth:width] + 7;
        }
    } else {
        for (NSInteger index = 0; index != comments.count; index++) {
            LTModelPostComment *comment = comments[index];
            LTPostCommentModel *model = [[LTPostCommentModel alloc] initWithComment:comment];
            height += [LTPostCommentCell heightWithAttributedString:model.text andWidth:width] + 7;
        }
    }
    if (limit < comments.count) {
        height += 30;
    }
    return height + 4 + [self topSpace];
}

+ (CGFloat)topSpace{
    return 6;
}

@end
