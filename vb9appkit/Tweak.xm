/*
 * vb9appkit/Tweak.xm
 * VolumeBar9
 *
 * Created by cgm616
 * Copyright (c) 2016 cgm616. All rights reserved.
 */

#import "Tweak.h"

%hook UIApplication

-(id)init {
  [OBJCIPC registerIncomingMessageFromSpringBoardHandlerForMessageName:@"me.cgm616.volumebar9.showing" handler:^NSDictionary *(NSDictionary *message) {
    UIStatusBar *statusBar = MSHookIvar<UIStatusBar *>([UIApplication sharedApplication], "_statusBar");
    UIStatusBarForegroundView *view = MSHookIvar<UIStatusBarForegroundView *>(statusBar, "_foregroundView");
    view.hidden = YES;

    NSDictionary *return_message = @{
      @"currentOrientation" : [NSNumber numberWithLongLong:[[UIApplication sharedApplication] statusBarOrientation]],
    };

	  return return_message;
  }];

  [OBJCIPC registerIncomingMessageFromSpringBoardHandlerForMessageName:@"me.cgm616.volumebar9.hiding" handler:^NSDictionary *(NSDictionary *message) {
    UIStatusBar *statusBar = MSHookIvar<UIStatusBar *>([UIApplication sharedApplication], "_statusBar");
    UIStatusBarForegroundView *view = MSHookIvar<UIStatusBarForegroundView *>(statusBar, "_foregroundView");
    view.hidden = NO;

	  return nil;
  }];

  return %orig;
}

-(void)setStatusBarOrientation:(UIInterfaceOrientation)orientation animationParameters:(id)arg2 notifySpringBoardAndFence:(BOOL)arg3 updateBlock:(id)arg4 {
  %log;
  %orig;

  [OBJCIPC sendMessageToSpringBoardWithMessageName:@"me.cgm616.volumebar9.orientation" dictionary:@{ @"orientation": [NSNumber numberWithLongLong:orientation] } replyHandler:^(NSDictionary *response) {}];
}

%end
