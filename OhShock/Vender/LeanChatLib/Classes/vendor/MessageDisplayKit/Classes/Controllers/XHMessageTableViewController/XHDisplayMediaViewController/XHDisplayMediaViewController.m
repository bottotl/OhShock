//
//  XHDisplayMediaViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-6.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHDisplayMediaViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

#import "UIView+XHRemoteImage.h"

@interface XHDisplayMediaViewController ()

@property (nonatomic, strong) AVPlayerViewController *moviePlayerController;

@property (nonatomic, weak) UIImageView *photoImageView;

@end

@implementation XHDisplayMediaViewController

- (AVPlayerViewController *)moviePlayerController {
    if (!_moviePlayerController) {
        _moviePlayerController = [[AVPlayerViewController alloc] init];
// 从MediaPlayer 改为 AVKit 后不会修改了
////        _moviePlayerController.repeatMode = MPMovieRepeatModeOne;
////        _moviePlayerController.scalingMode = MPMovieScalingModeAspectFill;
        _moviePlayerController.view.frame = self.view.frame;
        [self.view addSubview:_moviePlayerController.view];
    }
    return _moviePlayerController;
}

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        photoImageView.contentMode=UIViewContentModeScaleAspectFit;
        [self.view addSubview:photoImageView];
        _photoImageView = photoImageView;
    }
    return _photoImageView;
}

- (void)setMessage:(id<XHMessageModel>)message {
    _message = message;
    if ([message messageMediaType] == XHBubbleMessageMediaTypeVideo) {
        self.title = NSLocalizedStringFromTable(@"Video", @"MessageDisplayKitString", @"详细视频");
//warning 从MediaPlayer 改为 AVKit 后不会修改了
//        self.moviePlayerController.contentURL = [NSURL fileURLWithPath:[message videoPath]];
//        [self.moviePlayerController play];
    } else if ([message messageMediaType] ==XHBubbleMessageMediaTypePhoto) {
        self.title = NSLocalizedStringFromTable(@"Photo", @"MessageDisplayKitString", @"详细照片");
        self.photoImageView.image = message.photo;
        if (message.thumbnailUrl) {
            [self.photoImageView setImageWithURL:[NSURL URLWithString:[message thumbnailUrl]] placeholer:[UIImage imageNamed:@"placeholderImage"]];
        }
    }
}

#pragma mark - Life cycle

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.message messageMediaType] == XHBubbleMessageMediaTypeVideo) {
        //warning 从MediaPlayer 改为 AVKit 后不会修改了
//        [self.moviePlayerController stop];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    //warning 从MediaPlayer 改为 AVKit 后不会修改了
//    [_moviePlayerController stop];
    _moviePlayerController = nil;
    
    _photoImageView = nil;
}

@end
