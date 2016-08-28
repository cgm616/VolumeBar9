/*
 * VolumeBar.h
 * VolumeBar9
 *
 * Created by cgm616
 * Copyright (c) 2016 cgm616. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import <UIImage+Scale.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AudioToolbox/AudioToolbox.h>
#import "GMPVolumeView.h"
#import <UIKit/_UIBackdropView.h>
#import <UIKit/_UIBackdropViewSettings.h>
#import <SpringBoard/VolumeControl.h>
#import <Celestial/AVSystemController.h>
#import "Shared.h"
#include <tgmath.h>

@interface VolumeBar : NSObject {
	UIWindow *topWindow;
	UIView *mainView;
	_UIBackdropView *blurView;
	_UIBackdropViewSettings *blurSettings;
	UIView *handle;
	UIImage *thumbImage;
	UILabel *label;
  GMPVolumeView *volumeSlider;

  NSTimer *hide;

  CGFloat screenWidth;
  CGFloat screenHeight;

	CGFloat bannerWidth;
	CGFloat bannerX;
  CGFloat bannerHeight;
	CGFloat bannerY;

	CGFloat sliderWidth;
  CGFloat sliderX;
	CGFloat sliderHeight;
	CGFloat sliderY;

	id _view;

  NSBundle *_bundle;
}

@property (nonatomic) BOOL animate;
@property (nonatomic) BOOL userInteraction;
@property (nonatomic) BOOL showRouteButton;
@property (nonatomic) BOOL blur;
@property (nonatomic) BOOL drop;
@property (nonatomic) BOOL icon;
@property (nonatomic) BOOL statusBar;
@property (nonatomic) BOOL gesture;
@property (nonatomic) BOOL slideHandle;
@property (nonatomic) BOOL label;
@property (nonatomic) double delayTime;
@property (nonatomic) double speed;
@property (nonatomic) double height;
@property (nonatomic) int blurStyle;
@property (nonatomic) VB9GestureType gestureType;
@property (nonatomic) CGFloat statusBrightness;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic) BOOL sliderColorEnabled;
@property (nonatomic, strong) UIColor *minColor;
@property (nonatomic, strong) UIColor *maxColor;
@property (nonatomic, strong) CompletionBlock completion;

-(void)resetTimer;
-(void)_swipeHandler:(UISwipeGestureRecognizer *)recognizer;
-(void)adjustViewsForOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animateOrient;
-(void)_calculateRender;
-(void)_createHUD;
-(void)_addGestureToView:(UIView *)view;
-(void)_showHUD;
-(void)_hideHUD;
-(void)loadHUDView:(id)view orientation:(UIInterfaceOrientation)orientation;

@end
