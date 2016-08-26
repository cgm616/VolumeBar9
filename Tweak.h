/*
 * Tweak.h
 * VolumeBar9
 *
 * Created by cgm616
 * Copyright (c) 2016 cgm616. All rights reserved.
 */

#import <SpringBoard/SBHUDView.h>
#import <libcolorpicker.h>
#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
#import <SpringBoard/SBApplication.h>
#import <UIKit/UIStatusBarForegroundView.h>
#import <UIKit/UIStatusBarForegroundStyleAttributes.h>
#import <UIKit/UIStatusBarStyleAttributes.h>
#import <libobjcipc/objcipc.h>
#import "VolumeBar.h"

typedef void(^CompletionBlock)(void);

@interface SBHUDController

-(void)orientationChange:(NSNotification *)notification;
-(void)presentVolumeBarWithView:(id)view;

@end

@interface SBVolumeHUDView : SBHUDView {
}

@end
