/*
 * Tweak.xm
 * VolumeBar9
 *
 * Created by cgm616
 * Copyright (c) 2016 cgm616. All rights reserved.
 */

#import "Tweak.h"

static BOOL active;
static BOOL enabled;
static BOOL animate;
static BOOL userInteraction;
static BOOL showRouteButton;
static BOOL blur;
static BOOL drop;
static BOOL statusBar;
static BOOL slide;
static BOOL label;
static double delayTime;
static double speed;
static double height;
static int blurStyle;
static UIColor *color;
static UIColor *minColor;
static UIColor *maxColor;
static BOOL sliderColorEnabled;

static VolumeBar *vbar = nil;

static void preferenceUpdate(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	CFStringRef appID = CFSTR("me.cgm616.volumebar9");
	CFArrayRef keyList = CFPreferencesCopyKeyList(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
  if (!keyList) {
		HBLogError(@"There's been an error getting the key list!");
		return;
	}

	NSDictionary *preferences = (NSDictionary *)CFPreferencesCopyMultiple(keyList, appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
  if (!preferences) {
		HBLogError(@"There's been an error getting the preferences dictionary!");
	}
	CFRelease(keyList);

  HBLogDebug(@"Prefs dictionary has been updated to: %@", preferences);

  NSNumber *key = preferences[@"enabled"];
  enabled = key ? [key boolValue] : 1;

  key = preferences[@"animation"];
  animate = key ? [key boolValue] : 1;

  key = preferences[@"interaction"];
  userInteraction = key ? [key boolValue] : 1;

  key = preferences[@"routebutton"];
  showRouteButton = key ? [key boolValue] : 0;

  key = preferences[@"blur"];
  blur = key ? [key boolValue] : 1;

	key = preferences[@"drop"];
  drop = key ? [key boolValue] : 0;

	key = preferences[@"statusBar"];
	statusBar = key ? [key boolValue] : 0;

	key = preferences[@"slide"];
	slide = key ? [key boolValue] : 1;

	key = preferences[@"label"];
	label = key ? [key boolValue] : 0;

  key = preferences[@"timeon"];
  delayTime = key ? [key doubleValue] : 5.0;

  key = preferences[@"animatetime"];
  speed = key ? [key doubleValue] : 0.2;

	key = preferences[@"height"];
  height = key ? [key doubleValue] : 1.0;

  key = preferences[@"blurstyle"];
  blurStyle = key ? [key intValue] : 2;

  key = preferences[@"sliderColorEnabled"];
  sliderColorEnabled = key ? [key boolValue] : 0;

	color = [LCPParseColorString([preferences objectForKey:@"color"], @"#FFFFFF") retain];

  maxColor = [LCPParseColorString([preferences objectForKey:@"maxcolor"], @"#FFFFFF") retain];

  minColor = [LCPParseColorString([preferences objectForKey:@"mincolor"], @"#FFFFFF") retain];

	[preferences release];
}

%hook SBHUDController

%new(v@:);
-(void)orientationChange:(NSNotification *)notification {
  if(active && vbar != nil) {
    [vbar adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation] animated:YES];
  }
}

%new(v@:);
-(void)presentVolumeBarWithView:(id)view {
  HBLogDebug(@"Volume HUD hooked, VolumeBar enabled and showing");

  // TODO: pass in prefs as dictionary and handle defaults some other way
  if(!active) {
    active = true;
    vbar = [[VolumeBar alloc] init];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

    NSString *appID = [(SpringBoard *)[UIApplication sharedApplication] _accessibilityFrontMostApplication].bundleIdentifier;

    UIInterfaceOrientation startOrientation;
    CGFloat hue, saturation, brightness, alpha;

    if(appID) {
      NSDictionary *reply = [OBJCIPC sendMessageToAppWithIdentifier:appID messageName:@"me.cgm616.volumebar9.showing" dictionary:nil];
      startOrientation = [reply[@"currentOrientation"] longLongValue];
      brightness = [reply[@"foregroundBrightness"] floatValue];
    } else {
      UIStatusBar *statusBar = MSHookIvar<UIStatusBar *>([UIApplication sharedApplication], "_statusBar");
      UIStatusBarForegroundView *view = MSHookIvar<UIStatusBarForegroundView *>(statusBar, "_foregroundView");
      view.hidden = YES;
      startOrientation = [[UIApplication sharedApplication] statusBarOrientation];

      UIStatusBarStyleAttributes *style = MSHookIvar<UIStatusBarStyleAttributes *>(statusBar, "_styleAttributes");
      UIStatusBarForegroundStyleAttributes *foregroundStyle = MSHookIvar<UIStatusBarForegroundStyleAttributes *>(style, "_foregroundStyle");

      UIColor *foregroundColor = [foregroundStyle tintColor];
      [foregroundColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    }

  	vbar.color = color;
    vbar.sliderColorEnabled = sliderColorEnabled;
    vbar.minColor = minColor;
    vbar.maxColor = maxColor;
  	vbar.animate = animate;
  	vbar.userInteraction = userInteraction;
  	vbar.showRouteButton = showRouteButton;
  	vbar.blur = blur;
  	vbar.drop = drop;
  	vbar.statusBar = statusBar;
  	vbar.slide = slide;
  	vbar.label = label;
  	vbar.delayTime = delayTime;
  	vbar.speed = speed;
  	vbar.height = height;
  	vbar.blurStyle = blurStyle;
    vbar.statusBrightness = brightness;
    vbar.completion = ^{
      [vbar release];
      vbar = nil;
      if(appID) {
        [OBJCIPC sendMessageToAppWithIdentifier:appID messageName:@"me.cgm616.volumebar9.hiding" dictionary:@{} replyHandler:^(NSDictionary *response) {}];
      } else {
        UIStatusBar *statusBar = MSHookIvar<UIStatusBar *>([UIApplication sharedApplication], "_statusBar");
        UIStatusBarForegroundView *view = MSHookIvar<UIStatusBarForegroundView *>(statusBar, "_foregroundView");
        view.hidden = NO;
      }
      [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
      active = false;
    };
  	[vbar loadHUDView:view orientation:startOrientation];
  } else {
    if(vbar != nil) {
      [vbar resetTimer];
    }
  }
}

-(void)presentHUDView:(id)view autoDismissWithDelay:(double)delay {
  if([view isKindOfClass:objc_getClass("SBVolumeHUDView")] && enabled) {
    [self presentVolumeBarWithView:view];
  } else {
    %orig;
  }
}

-(void)presentHUDView:(id)view {
  if([view isKindOfClass:objc_getClass("SBVolumeHUDView")] && enabled) {
    [self presentVolumeBarWithView:view];
  } else {
    %orig;
  }
}

%end

%hook VolumeControl

-(void)_changeVolumeBy:(CGFloat)arg1 {
  if(active && vbar != nil) {
    [vbar resetTimer];
  }

  %orig;
}

%end

%hook MPVolumeController

-(float)setVolumeValue:(float)arg1 {
  if(active && vbar != nil) {
    [vbar resetTimer];
  }

  return %orig;
}

%end

%ctor {
  [OBJCIPC registerIncomingMessageFromAppHandlerForMessageName:@"me.cgm616.volumebar9.orientation"  handler:^NSDictionary *(NSDictionary *message) {
    if(active && vbar != nil) {
      [vbar adjustViewsForOrientation:[message[@"orientation"] longLongValue] animated:YES];
    }

    return nil;
  }];

  preferenceUpdate(nil,nil,nil,nil,nil);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)preferenceUpdate, CFSTR("me.cgm616.volumebar9/preferences.changed"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}

%dtor {
  [color release];
  [minColor release];
  [maxColor release];
}
