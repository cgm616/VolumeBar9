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
    UIStatusBarForegroundStyleAttributes *foregroundStyle = nil;

    UIStatusBar *statusBar = MSHookIvar<UIStatusBar *>([UIApplication sharedApplication], "_statusBar");
    if(statusBar) {
      UIStatusBarForegroundView *view = MSHookIvar<UIStatusBarForegroundView *>(statusBar, "_foregroundView");
      if(view) {
        view.hidden = YES;
      }

      UIStatusBarStyleAttributes *style = MSHookIvar<UIStatusBarStyleAttributes *>(statusBar, "_styleAttributes");
      if(style) {
        foregroundStyle = MSHookIvar<UIStatusBarForegroundStyleAttributes *>(style, "_foregroundStyle");
      }
    }

    UIColor *foregroundColor = foregroundStyle ? [foregroundStyle tintColor] : [UIColor blackColor];

    CGFloat hue, saturation, brightness, alpha;
    [foregroundColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

    NSDictionary *return_message = @{
      @"currentOrientation" : [NSNumber numberWithLongLong:[[UIApplication sharedApplication] statusBarOrientation]],
      @"foregroundBrightness" : [NSNumber numberWithFloat:brightness],
      @"foregroundHue" : [NSNumber numberWithFloat:hue],
      @"foregroundSaturation" : [NSNumber numberWithFloat:saturation],
      @"foregroundAlpha" : [NSNumber numberWithFloat:alpha],
    };

	  return return_message;
  }];

  [OBJCIPC registerIncomingMessageFromSpringBoardHandlerForMessageName:@"me.cgm616.volumebar9.hiding" handler:^NSDictionary *(NSDictionary *message) {
    UIStatusBar *statusBar = MSHookIvar<UIStatusBar *>([UIApplication sharedApplication], "_statusBar");
    if(statusBar) {
      UIStatusBarForegroundView *view = MSHookIvar<UIStatusBarForegroundView *>(statusBar, "_foregroundView");
      if(view) {
        view.hidden = NO;
      }
    }

	  return nil;
  }];

  return %orig;
}

-(void)setStatusBarOrientation:(UIInterfaceOrientation)orientation animationParameters:(id)arg2 notifySpringBoardAndFence:(BOOL)arg3 updateBlock:(id)arg4 {
  [OBJCIPC sendMessageToSpringBoardWithMessageName:@"me.cgm616.volumebar9.orientation" dictionary:@{ @"orientation": [NSNumber numberWithLongLong:orientation] } replyHandler:^(NSDictionary *response) {}];

  %orig;
}

%end
