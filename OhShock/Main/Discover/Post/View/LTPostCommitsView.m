//
//  LTPostCommitsView.m
//  OhShock
//
//  Created by Lintao.Yu on 1/9/16.
//  Copyright © 2016 Lintao Yu. All rights reserved.
//

#import "LTPostCommitsView.h"
#import "YYKit.h"

@interface LTPostCommitsView ()

@property (nonatomic, strong) YYLabel *commitLabel;

@property (nonatomic, strong) NSAttributedString *commits;

@end

@implementation LTPostCommitsView

#pragma mark - property

-(YYLabel *)commitLabel{
    if (!_commitLabel) {
        _commitLabel = [YYLabel new];
        _commitLabel.numberOfLines = 0;
        [self addSubview:_commitLabel];
    }
    return _commitLabel;
}

-(CGSize)sizeThatFits:(CGSize)size{
    CGSize tempSize = CGSizeMake(self.width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:tempSize text:self.commits];
    self.commitLabel.attributedText = self.commits;
    self.commitLabel.size = layout.textBoundingSize;

    return self.commitLabel.size;
}

#pragma mark - 数据配置
-(void)configWithData:(LTPostCommitModel *)data{
    self.commits = [[self class]commitsToNSAttributedString:data.commits];
}

//换行
+ (NSAttributedString *)padding {
    NSMutableAttributedString *pad = [[NSMutableAttributedString alloc] initWithString:@"\n\n"];
    pad.font = [UIFont systemFontOfSize:4];
    return pad;
}

#pragma mark - 计算高度
+(CGFloat)heightWithData:(LTPostCommitModel *)data andWidth:(CGFloat)width{
    
    
    CGSize tempSize = CGSizeMake(width, CGFLOAT_MAX);
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:tempSize text:[[self class]commitsToNSAttributedString:data.commits]];
    return layout.textBoundingSize.height;
}

+(NSAttributedString *)commitsToNSAttributedString:(NSArray *)commits{
    
    NSMutableAttributedString *commitList = [NSMutableAttributedString new];
    NSUInteger commitCount = commits.count;
    NSUInteger index = 0;
    for (NSAttributedString *commit in commits) {
        [commitList appendAttributedString:commit];
        if (index != commitCount) {
            [commitList appendAttributedString:[[self class]padding]];
            index ++;
        }
    }
    return commitList.copy;
}

@end
