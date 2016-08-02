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
#import "VolumeBar.h"

@interface SBHUDController

-(void)presentVolumeBarWithView:(id)view;

@end

@interface SBVolumeHUDView : SBHUDView {
}

@end
