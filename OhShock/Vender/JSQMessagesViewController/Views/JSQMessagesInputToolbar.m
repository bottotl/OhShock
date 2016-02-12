//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQMessagesInputToolbar.h"

#import "JSQMessagesComposerTextView.h"

#import "JSQMessagesToolbarButtonFactory.h"

#import "UIColor+JSQMessages.h"
#import "UIImage+JSQMessages.h"
#import "UIView+JSQMessages.h"

static void * kJSQMessagesInputToolbarKeyValueObservingContext = &kJSQMessagesInputToolbarKeyValueObservingContext;


@interface JSQMessagesInputToolbar ()

//@property (assign, nonatomic) BOOL jsq_isObserving;

//- (void)jsq_leftBarButtonPressed:(UIButton *)sender;
//- (void)jsq_rightBarButtonPressed:(UIButton *)sender;
- (void)jsq_rightBarButtonPressed:(UIButton *)sender atIndex:(NSUInteger) index;

//- (void)jsq_addObservers;
//- (void)jsq_removeObservers;

@end



@implementation JSQMessagesInputToolbar

@dynamic delegate;

#pragma mark - Initialization
-(instancetype)initWithSubView:(UIView *)SubView{
    self = [super init];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.preferredDefaultHeight = 44.0f;
        self.maximumHeight = NSNotFound;
        
        JSQMessagesToolbarContentView *toolbarContentView = [self loadToolbarContentView];
        toolbarContentView.frame = self.frame;
        [self addSubview:toolbarContentView];
        [self jsq_pinAllEdgesOfSubview:toolbarContentView];
        [self setNeedsUpdateConstraints];
        _contentView = toolbarContentView;
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];

//    self.jsq_isObserving = NO;
//    self.sendButtonOnRight = YES;

    self.preferredDefaultHeight = 44.0f;
    self.maximumHeight = NSNotFound;

    JSQMessagesToolbarContentView *toolbarContentView = [self loadToolbarContentView];
    toolbarContentView.frame = self.frame;
    [self addSubview:toolbarContentView];
    [self jsq_pinAllEdgesOfSubview:toolbarContentView];
    [self setNeedsUpdateConstraints];
    _contentView = toolbarContentView;
    
    
//    [self jsq_addObservers];
//    self.contentView.leftBarButtonItem = [JSQMessagesToolbarButtonFactory defaultAccessoryButtonItem];
//    self.contentView.rightBarButtonItem = [JSQMessagesToolbarButtonFactory defaultSendButtonItem];
    //添加右侧多个按钮
    [self.contentView setRightBarButtonItems:@[[JSQMessagesToolbarButtonFactory defaultAccessoryButtonItem], [JSQMessagesToolbarButtonFactory defaultAccessoryButtonItem]] andWidths:@[@40, @40]];
    [self jsq_addTargetsForRightButtons];
    
    
//    [self toggleSendButtonEnabled];
}

/**
 *  添加按钮方法
 *
 *  @param rightBarButtonItems buttons
 *  @param widths              button widths
 */
-(void)setRightBarButtonItems:(NSArray < UIButton *>*)rightBarButtonItems andWidths:(NSArray < NSNumber * >*)widths{
    [self.contentView setRightBarButtonItems:rightBarButtonItems andWidths:widths];
    ////为右侧按钮添加事件
    [self jsq_addTargetsForRightButtons];
}

-(void)setLeftBarButtonItems:(NSArray<UIButton *> *)leftBarButtonItems andWidths:(NSArray<NSNumber *> *)widths{
    [self.contentView setLeftBarButtonItems:leftBarButtonItems andWidths:widths];
    
}


- (JSQMessagesToolbarContentView *)loadToolbarContentView
{
    NSArray *nibViews = [[NSBundle bundleForClass:[JSQMessagesInputToolbar class]] loadNibNamed:NSStringFromClass([JSQMessagesToolbarContentView class])
                                                                                          owner:nil
                                                                                        options:nil];
    return nibViews.firstObject;
}

- (void)dealloc
{
//    [self jsq_removeObservers];
    _contentView = nil;
}

#pragma mark - Setters

- (void)setPreferredDefaultHeight:(CGFloat)preferredDefaultHeight
{
    NSParameterAssert(preferredDefaultHeight > 0.0f);
    _preferredDefaultHeight = preferredDefaultHeight;
}

#pragma mark - Actions

//- (void)jsq_leftBarButtonPressed:(UIButton *)sender
//{
//    [self.delegate messagesInputToolbar:self didPressLeftBarButton:sender];
//}
//
//- (void)jsq_rightBarButtonPressed:(UIButton *)sender
//{
//    [self.delegate messagesInputToolbar:self didPressRightBarButton:sender];
//}

- (void)jsq_rightBarButtonPressed:(UIButton *)sender atIndex:(NSUInteger)index{
    [self.delegate messagesInputToolbar:self didPressRightBarButton:sender atIndex:sender.tag];
}
- (void)jsq_leftBarButtonPressed:(UIButton *)sender atIndex:(NSUInteger)index{
    [self.delegate messagesInputToolbar:self didPressRightBarButton:sender atIndex:sender.tag];
}


//#pragma mark - Input toolbar
//
//- (void)toggleSendButtonEnabled
//{
//    BOOL hasText = [self.contentView.textView hasText];
//
//    if (self.sendButtonOnRight) {
//        self.contentView.rightBarButtonItem.enabled = hasText;
//    }
//    else {
//        self.contentView.leftBarButtonItem.enabled = hasText;
//    }
//}

//#pragma mark - Key-value observing
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if (context == kJSQMessagesInputToolbarKeyValueObservingContext) {
//        if (object == self.contentView) {
//
//            if ([keyPath isEqualToString:NSStringFromSelector(@selector(leftBarButtonItem))]) {
//
//                [self.contentView.leftBarButtonItem removeTarget:self
//                                                          action:NULL
//                                                forControlEvents:UIControlEventTouchUpInside];
//
//                [self.contentView.leftBarButtonItem addTarget:self
//                                                       action:@selector(jsq_leftBarButtonPressed:)
//                                             forControlEvents:UIControlEventTouchUpInside];
//            }
//            else if ([keyPath isEqualToString:NSStringFromSelector(@selector(rightBarButtonItem))]) {
//
//                [self.contentView.rightBarButtonItem removeTarget:self
//                                                           action:NULL
//                                                 forControlEvents:UIControlEventTouchUpInside];
//
//                [self.contentView.rightBarButtonItem addTarget:self
//                                                        action:@selector(jsq_rightBarButtonPressed:)
//                                              forControlEvents:UIControlEventTouchUpInside];
//            }
//            
//            [self toggleSendButtonEnabled];
//        }
//    }
//}

- (void)jsq_addTargetsForRightButtons{
    //为右侧按钮添加事件
    for (int i = 0; i <  self.contentView.rightBarButtonItems.count; i++) {
        UIButton *rightButtonItem = self.contentView.rightBarButtonItems[i];
        rightButtonItem.tag = i;//给button加标记方便识别
        [rightButtonItem removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [rightButtonItem addTarget:self action:@selector(jsq_rightBarButtonPressed:atIndex:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)jsq_addTargetsForLeftButtons{
    for (int i = 0; i <  self.contentView.leftBarButtonItems.count; i++) {
        UIButton *leftButtonItem = self.contentView.leftBarButtonItems[i];
        leftButtonItem.tag = i;//给button加标记方便识别
        [leftButtonItem removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [leftButtonItem addTarget:self action:@selector(jsq_rightBarButtonPressed:atIndex:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//- (void)jsq_addObservers
//{
//    if (self.jsq_isObserving) {
//        return;
//    }
//
//    [self.contentView addObserver:self
//                       forKeyPath:NSStringFromSelector(@selector(leftBarButtonItem))
//                          options:0
//                          context:kJSQMessagesInputToolbarKeyValueObservingContext];
//
//    [self.contentView addObserver:self
//                       forKeyPath:NSStringFromSelector(@selector(rightBarButtonItem))
//                          options:0
//                          context:kJSQMessagesInputToolbarKeyValueObservingContext];
//
//    
//    self.jsq_isObserving = YES;
//}

//- (void)jsq_removeObservers
//{
//    if (!_jsq_isObserving) {
//        return;
//    }
//
//    @try {
//        [_contentView removeObserver:self
//                          forKeyPath:NSStringFromSelector(@selector(leftBarButtonItem))
//                             context:kJSQMessagesInputToolbarKeyValueObservingContext];
//
//        [_contentView removeObserver:self
//                          forKeyPath:NSStringFromSelector(@selector(rightBarButtonItem))
//                             context:kJSQMessagesInputToolbarKeyValueObservingContext];
//    }
//    @catch (NSException *__unused exception) { }
//    
//    _jsq_isObserving = NO;
//}

@end
