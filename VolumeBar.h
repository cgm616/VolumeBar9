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
#import <MediaPlayer/MediaPlayer.h>
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

	GMPVolumeView *volumeSlider;
	UISlider *ringerSlider;
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

	CGPoint windowCenter;
	CGAffineTransform transform;

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
@property (nonatomic, strong) CompletionBlock completion;

-(void)swipeHandler:(UISwipeGestureRecognizer *)recognizer;
-(void)ringerSliderAction:(id)sender;
-(void)ringerChanged:(NSNotification *)notification;
-(void)adjustViewsForOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animateOrient;
-(void)orientationChanged:(NSNotification *)notification;
-(void)calculateRender;
-(void)createHUD;
-(void)showHUD;
-(void)hideHUD;
-(void)loadHUDWithView:(id)view;

@end
