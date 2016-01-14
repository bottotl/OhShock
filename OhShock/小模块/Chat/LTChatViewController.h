//
//  LTChatViewController.h
//  OhShock
//
//  Created by Lintao.Yu on 15/12/16.
//  Copyright © 2015年 Lintao Yu. All rights reserved.
//

#import "JSQMessagesViewController.h"


@class AVUser;
@interface LTChatViewController : JSQMessagesViewController<JSQMessagesComposerTextViewPasteDelegate>

-(instancetype)initWithUser:(AVUser *)user;
@end
