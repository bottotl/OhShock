//
//  DiscoverTodoCell.m
//  ToChat
//
//  Created by syfll on 15/8/19.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

#import "DiscoverTodoCell.h"
#import "Masonry.h"
@interface DiscoverTodoCell()
/// 标记是否已经设置了限制
@property (nonatomic, assign) BOOL didSetupConstraints;

/// 用来显示用户头像
@property (strong, nonatomic) UIImageView *ownerImgView;
/// 用来显示用户名
@property (strong, nonatomic) UILabel *userNameLabel;
/// 用来显示“发布了一个日程” 、“参与了一个日程”等信息
@property (strong, nonatomic) UILabel *actionLabel;
/// 用来显示内容的背景
@property (strong, nonatomic) UIView *todoBackView;
/// 用来显示内容
@property (strong, nonatomic) UILabel *contentLabel;
/// 用来显示时钟图片
@property (strong, nonatomic) UIImageView *clockImageView;
/// 用来显示日程执行的时间
@property (strong, nonatomic) UILabel *todoTimeLabel;
/// 用来显示地理信息图片
@property (strong, nonatomic) UIImageView *locationImageView;
/// 用来显示地理信息
@property (strong, nonatomic) UILabel *todoLocationLabel;
/// 用来显示发表的时间
@property (strong, nonatomic) UILabel *publishTimeLabel;
/// “参与人数”&“评论”上方的（水平）分割线
@property (strong, nonatomic) UIView *HorizontalSeparateLine;
/// “参与人数”&“评论”之间的的（垂直）分割线
@property (strong, nonatomic) UIView *VerticalSeparateLine;
/// 用来显示参与人数
@property (strong, nonatomic) UIButton *joinNumButton;
/// 用来显示评论数量
@property (strong, nonatomic) UIButton *commentNumButton;

@end

@implementation DiscoverTodoCell

- (void)awakeFromNib {
    // Initialization code
}
-(nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self loadViews];
    [self updateConstraints];
    return self;
}

- (void)setEntity:(LKAlarmEvent *)entity
{
    _entity = entity;
    
    [self.ownerImgView setImage:[UIImage imageNamed:@"time_clock_icon"]];
    
    
    [self.userNameLabel setText:@"一蓑烟雨"];
    
    [self.actionLabel  setText:@"添加了一个日程"];
    
    [self.contentLabel setText:@"这是测试内容~~~~~~~~这是测试内容~~~~~~~~这是测试内容~~~~~~~~这是测试内容~~~~~~~~"];
    [self.clockImageView setImage:[UIImage imageNamed:@"time_clock_icon"]];
    [self.todoTimeLabel setText:@"2015年8月7日"];
    [self.locationImageView setImage:[UIImage imageNamed:@"time_clock_icon"]];
    [self.todoLocationLabel setText:@"（前面的图片需要改）武汉大学"];
    [self.publishTimeLabel setText:@"24分钟前"];
    [self.HorizontalSeparateLine setBackgroundColor:[UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1]];
    [self.VerticalSeparateLine setBackgroundColor:[UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1]];
    [self.joinNumButton setImage:[UIImage imageNamed:@"time_clock_icon"] forState:UIControlStateNormal];
    [self.joinNumButton setTitle:@"参与人数 10" forState:UIControlStateNormal];
    
    [self.commentNumButton setImage:[UIImage imageNamed:@"time_clock_icon"]forState:UIControlStateNormal];
    
    [self.commentNumButton setTitle:@"评论 10" forState:UIControlStateNormal];

}
-(void)loadViews{
    self.contentView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    
    self.ownerImgView = [[UIImageView alloc]initWithFrame:CGRectZero];
    //[self.ownerImgView doCircleFrame];
    
    self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.userNameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.userNameLabel setNumberOfLines:1];
    [self.userNameLabel setTextAlignment:NSTextAlignmentLeft];
    [self.userNameLabel setTextColor:[UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1]];
    //self.userNameLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.1];
    
    self.actionLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.actionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.actionLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.actionLabel setNumberOfLines:1];
    [self.actionLabel setTextAlignment:NSTextAlignmentLeft];
    [self.actionLabel setTextColor:[UIColor colorWithRed:177.0/255.0 green:177.0/255.0 blue:177.0/255.0 alpha:1]];
    //self.actionLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.1];
    
    
    self.todoBackView = [[UIView alloc]initWithFrame:CGRectZero];
    self.todoBackView.layer.masksToBounds = YES;
    self.todoBackView.layer.cornerRadius = 20;
    self.todoBackView.layer.borderWidth = 0;
    
    [self.todoBackView setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1]];
    
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.contentLabel setNumberOfLines:6];
    [self.contentLabel setTextAlignment:NSTextAlignmentLeft];
    [self.contentLabel setTextColor:[UIColor colorWithRed:48.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1]];
    
    
    
    self.clockImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    
    
    self.todoTimeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.todoTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.todoTimeLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.todoTimeLabel setNumberOfLines:1];
    [self.todoTimeLabel setTextAlignment:NSTextAlignmentLeft];
    [self.todoTimeLabel setTextColor:[UIColor colorWithRed:50.0/255.0 green:177.0/255.0 blue:108.0/255.0 alpha:1]];
    //self.todoTimeLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.1];
    
    
    self.locationImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    
    
    self.todoLocationLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.todoLocationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.todoLocationLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.todoLocationLabel setNumberOfLines:1];
    [self.todoLocationLabel setTextAlignment:NSTextAlignmentLeft];
    [self.todoLocationLabel setTextColor:[UIColor colorWithRed:50.0/255.0 green:177.0/255.0 blue:108.0/255.0 alpha:1]];
    //self.todoLocationLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.1];
    
    
    self.publishTimeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.publishTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.publishTimeLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.publishTimeLabel setNumberOfLines:1];
    [self.publishTimeLabel setTextAlignment:NSTextAlignmentLeft];
    [self.publishTimeLabel setTextColor:[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1]];
    
    self.HorizontalSeparateLine = [[UIView alloc]initWithFrame:CGRectZero];
    
    
    self.VerticalSeparateLine = [[UIView alloc]initWithFrame:CGRectZero];
    
    
    self.joinNumButton = [[UIButton alloc]initWithFrame:CGRectZero];

    [self.joinNumButton setTitleColor:[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1] forState:UIControlStateNormal];
    
    self.commentNumButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.commentNumButton setTitleColor:[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1] forState:UIControlStateNormal];
    
    //设置字体
    [self updateFonts];
    
    [self.contentView addSubview:self.ownerImgView];
    [self.contentView addSubview:self.userNameLabel];
    [self.contentView addSubview:self.actionLabel];
    [self.contentView addSubview:self.todoBackView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.clockImageView];
    [self.contentView addSubview:self.todoTimeLabel];
    [self.contentView addSubview:self.locationImageView];
    [self.contentView addSubview:self.todoLocationLabel];
    [self.contentView addSubview:self.publishTimeLabel];
    [self.contentView addSubview:self.HorizontalSeparateLine];
    [self.contentView addSubview:self.VerticalSeparateLine];
    [self.contentView addSubview:self.joinNumButton];
    [self.contentView addSubview:self.commentNumButton];
    
    
}

//  依靠contentLabel、clockImageView、locationImageView 给 todoBackView压力，使其扩张
//  依靠ownerImgView、todoBackView、publishTimeLabel、joinNumButton给contentView压力，使其扩张
-(void)updateConstraints{
    if(!self.didSetupConstraints){
        [self.ownerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            //self.ownerImgView.backgroundColor = []
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.height.equalTo(@60);
            make.width.equalTo(@60);
        }];
        [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ownerImgView.mas_right).offset(5);
            make.centerY.equalTo(self.ownerImgView.mas_centerY);
        }];
        [self.actionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userNameLabel.mas_right).offset(5);
            make.centerY.equalTo(self.ownerImgView.mas_centerY);
        }];
        [self.todoBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ownerImgView.mas_right).offset(-7);
            make.top.equalTo(self.ownerImgView.mas_bottom).offset(3);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
        }];
        [self.publishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ownerImgView.mas_right).offset(3);
            make.top.equalTo(self.todoBackView.mas_bottom).offset(8);
        }];
        [self.HorizontalSeparateLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(20);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.height.equalTo(@0.5);
            make.top.equalTo(self.publishTimeLabel.mas_bottom).offset(5);
        }];
        [self.VerticalSeparateLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0.5);
            make.top.equalTo(self.HorizontalSeparateLine.mas_bottom).offset(2);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-2);
            make.centerX.equalTo(self.HorizontalSeparateLine.mas_centerX);
        }];
        [self.joinNumButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.HorizontalSeparateLine.mas_left);
            make.right.equalTo(self.commentNumButton.mas_left);
            make.top.equalTo(self.HorizontalSeparateLine.mas_bottom);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.equalTo(@30);
        }];
        [self.commentNumButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.HorizontalSeparateLine.mas_right);
            make.top.equalTo(self.HorizontalSeparateLine.mas_bottom);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.width.equalTo(self.joinNumButton.mas_width);
        }];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.todoBackView.mas_left).offset(16);
            make.right.lessThanOrEqualTo(self.todoBackView.mas_right).offset(-16);
            make.top.equalTo(self.todoBackView.mas_top).offset(16);
        }];
        [self.clockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentLabel.mas_left);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(16);
            make.height.equalTo(@10);
            make.width.equalTo(@10);
        }];
        [self.todoTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.clockImageView.mas_right).offset(2);
            make.right.lessThanOrEqualTo(self.todoBackView.mas_right).offset(5);
            make.centerY.equalTo(self.clockImageView.mas_centerY);
        }];
        [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.clockImageView.mas_centerX);
            make.top.equalTo(self.clockImageView.mas_bottom).offset(12);
            make.height.equalTo(self.clockImageView.mas_height);
            make.width.equalTo(self.clockImageView.mas_width);
            make.bottom.equalTo(self.todoBackView.mas_bottom).offset(-16);
        }];
        [self.todoLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.locationImageView.mas_right).offset(2);
            make.centerY.equalTo(self.locationImageView.mas_centerY);
            make.right.lessThanOrEqualTo(self.todoBackView.mas_right).offset(5);
        }];
        self.didSetupConstraints = true;
    }
    
    [super updateConstraints];
    
}
/// 设置字体
- (void)updateFonts
{
    self.userNameLabel.font = [UIFont systemFontOfSize :18.f];
    self.actionLabel.font = [UIFont systemFontOfSize:16.0f];
    
    self.contentLabel.font = [UIFont systemFontOfSize:18.0f];
    self.todoTimeLabel.font = [UIFont systemFontOfSize:15.0f];
    self.todoLocationLabel.font = [UIFont systemFontOfSize:15.0f];
    self.publishTimeLabel.font = [UIFont systemFontOfSize:16.0f];
    self.joinNumButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.commentNumButton.titleLabel.font = [UIFont systemFontOfSize:16];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
