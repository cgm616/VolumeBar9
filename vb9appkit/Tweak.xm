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
    BOOL status = statusBar.hidden;
    statusBar.hidden = YES;

    NSDictionary *return_message = @{
      @"statusBarHidden" : [NSNumber numberWithBool:status],
      @"currentOrientation" : [NSNumber numberWithLongLong:[[UIApplication sharedApplication] statusBarOrientation]],
    };

	  return return_message;
  }];

  [OBJCIPC registerIncomingMessageFromSpringBoardHandlerForMessageName:@"me.cgm616.volumebar9.hiding" handler:^NSDictionary *(NSDictionary *message) {
	  BOOL previousStatus = [message[@"statusBarHidden"] boolValue];

    UIStatusBar *statusBar = MSHookIvar<UIStatusBar *>([UIApplication sharedApplication], "_statusBar");
    statusBar.hidden = previousStatus;

	  return nil;
  }];

  return %orig;
}

%end
