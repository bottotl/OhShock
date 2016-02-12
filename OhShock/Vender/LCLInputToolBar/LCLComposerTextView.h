//
//  LCLComposerTextView.h
//  OhShock
//
//  Created by lintao.yu on 16/2/12.
//  Copyright © 2016年 Lintao Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCLComposerTextView;

/**
 *  A delegate object used to notify the receiver of paste events from a `JSQMessagesComposerTextView`.
 */
@protocol LCLComposerTextViewPasteDelegate <NSObject>

/**
 *  Asks the delegate whether or not the `textView` should use the original implementation of `-[UITextView paste]`.
 *
 *  @discussion Use this delegate method to implement custom pasting behavior.
 *  You should return `NO` when you want to handle pasting.
 *  Return `YES` to defer functionality to the `textView`.
 */
- (BOOL)composerTextView:(LCLComposerTextView *)textView shouldPasteWithSender:(id)sender;

@end

@interface LCLComposerTextView : UITextView

@property (copy, nonatomic) NSString *placeHolder;

@property (strong, nonatomic) UIColor *placeHolderTextColor;

@property (weak, nonatomic) id<LCLComposerTextViewPasteDelegate> pasteDelegate;

- (BOOL)hasText;

@end
