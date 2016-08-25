/*
 * VolumeBar.h
 * VolumeBar9
 *
 * Created by cgm616
 * Copyright (c) 2016 cgm616. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AudioToolbox/AudioToolbox.h>
#import "GMPVolumeView.h"
#import <UIKit/_UIBackdropView.h>
#import <UIKit/_UIBackdropViewSettings.h>
#import <SpringBoard/VolumeControl.h>
#import <Celestial/AVSystemController.h>
#include <tgmath.h>

typedef void(^CompletionBlock)(void);

@interface VolumeBar : NSObject {
	UIWindow *topWindow;
	UIView *mainView;
	_UIBackdropView *blurView;
	_UIBackdropViewSettings *blurSettings;
	UISwipeGestureRecognizer *swipeRecognizer;
	UIView *handle;
	UIImage *thumbImage;
	UILabel *label;

  NSTimer *hide;

	GMPVolumeView *volumeSlider;
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
}

@property (nonatomic) BOOL animate;
@property (nonatomic) BOOL userInteraction;
@property (nonatomic) BOOL showRouteButton;
@property (nonatomic) BOOL blur;
@property (nonatomic) BOOL drop;
@property (nonatomic) BOOL statusBar;
@property (nonatomic) BOOL slide;
@property (nonatomic) BOOL label;
@property (nonatomic) double delayTime;
@property (nonatomic) double speed;
@property (nonatomic) double height;
@property (nonatomic) int blurStyle;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic) BOOL sliderColorEnabled;
@property (nonatomic, strong) UIColor *minColor;
@property (nonatomic, strong) UIColor *maxColor;
@property (nonatomic, strong) CompletionBlock completion;

-(void)resetTimer;
-(void)swipeHandler:(UISwipeGestureRecognizer *)recognizer;
-(void)adjustViewsForOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animateOrient;
-(void)calculateRender;
-(void)createHUD;
-(void)showHUD;
-(void)hideHUD;
-(void)loadHUDView:(id)view orientation:(UIInterfaceOrientation)orientation;

@end
