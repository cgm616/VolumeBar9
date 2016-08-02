/*
 * VolumeBar.xm
 * VolumeBar9
 *
 * Created by cgm616
 * Copyright (c) 2016 cgm616. All rights reserved.
 */

#import "VolumeBar.h"

@implementation VolumeBar

@synthesize color = _color;
@synthesize animate = _animate;
@synthesize userInteraction = _userInteraction;
@synthesize showRouteButton = _showRouteButton;
@synthesize blur = _blur;
@synthesize drop = _drop;
@synthesize statusBar = _statusBar;
@synthesize slide = _slide;
@synthesize label = _label;
@synthesize delayTime = _delayTime;
@synthesize speed = _speed;
@synthesize height = _height;
@synthesize blurStyle = _blurStyle;

+(VolumeBar*)sharedInstance { // sharedInstance keeps the same object between views, so no alloc/init in Tweak.xm
  static dispatch_once_t p = 0;
  __strong static id _sharedObject = nil;
  dispatch_once(&p, ^{
    _sharedObject = [[self alloc] init];
  });
  return _sharedObject;
}

-(void)swipeHandler:(UITapGestureRecognizer *)gestureRecognizer { // stops hide timer and calls hideHUD when swiped
  HBLogDebug(@"swipeHandler called");
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideHUD) object:nil];
  [self hideHUD];
}

-(void)ringerSliderAction:(id)sender { // updates volume when ringer slider changed TODO: make less resource instensive
  HBLogDebug(@"ringerSliderAction called");
  UISlider *slider = (UISlider*)sender;

  AVSystemController *controller = [NSClassFromString(@"AVSystemController") sharedAVSystemController];
  // CGFloat delta = slider.value - [controller getVolume:&oldVolume forCategory:@"Ringtone"];
  [controller setVolumeTo:slider.value forCategory:@"Ringtone"];

  /*
  VolumeControl *volumeControl = [NSClassFromString(@"VolumeControl") sharedVolumeControl];
  CGFloat delta = slider.value - [volumeControl volume];
  [volumeControl _changeVolumeBy:delta];
  */
}

-(void)ringerChanged:(NSNotification *)notification { // handles changing slider value when buttons pressed with ringer
  // TODO: don't update slider value while finger is dragging
  HBLogDebug(@"ringerChanged called");
  NSDictionary *dict = notification.userInfo;
  float value = [[dict objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
  [ringerSlider setValue:value animated:YES];
}

-(void)adjustViewsForOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animateOrient{
  switch (orientation) {
    case UIInterfaceOrientationPortraitUpsideDown:
    {
      HBLogDebug(@"Portrait upside down");
      transform = CGAffineTransformMakeRotation(M_PI);
      windowCenter = CGPointMake(bannerWidth / 2, screenHeight - (bannerHeight / 2));
    } break;

    case UIInterfaceOrientationLandscapeLeft:
    {
      HBLogDebug(@"Landscape left");
      transform = CGAffineTransformMakeRotation(M_PI / -2);
      windowCenter = CGPointMake(bannerHeight / 2, screenHeight / 2);
    }break;

    case UIInterfaceOrientationLandscapeRight:
    {
      HBLogDebug(@"Landscape right");
      transform = CGAffineTransformMakeRotation(M_PI / 2);
      windowCenter = CGPointMake(screenWidth - (bannerHeight / 2), screenHeight / 2);
    } break;

    case UIInterfaceOrientationUnknown:
    case UIInterfaceOrientationPortrait:
    default:
    {
      HBLogDebug(@"Portrait, no change");
      transform = CGAffineTransformMakeRotation(0);
      windowCenter = CGPointMake(screenWidth / 2, bannerHeight / 2);
    }break;
  }

  if(animateOrient) {
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
      [topWindow setTransform:transform];
      topWindow.center = windowCenter;
    } completion:nil];
  } else {
    [topWindow setTransform:transform];
    topWindow.center = windowCenter;
  }
}

-(void)orientationChanged:(NSNotification *)notification {
  [self adjustViewsForOrientation:[[notification object] orientation] animated:YES];
}

-(void)calculateRender { // does frame calculations and creates thumbImage
  HBLogDebug(@"calculateRender called");
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  screenWidth = screenRect.size.width;
  screenHeight = screenRect.size.height;

  bannerX = 0;
  bannerWidth = screenWidth;
	bannerY = 0;
  bannerHeight = 40 * _height;

  sliderX = screenWidth / 16;
  sliderWidth = screenWidth - (2 * sliderX);
  sliderY = 0;

  if(_statusBar) {
    CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
    float statusBarHeight = MIN(statusBarSize.width, statusBarSize.height);
    bannerHeight = statusBarHeight > 20 ? statusBarHeight : 20;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(2, 2), NO, 0.0);
    thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  }

  sliderHeight = bannerHeight;

  if(_slide && !_statusBar) {
    bannerHeight = bannerHeight + 12;
  }

  if(_label && !_statusBar) {
    sliderY = sliderY + 14;
    bannerHeight = bannerHeight + sliderY;
  }
}

-(void)createHUD { // creates view heirarchy
  HBLogDebug(@"createHUD called");
  [self calculateRender];

  topWindow = [[UIWindow alloc] initWithFrame:CGRectMake(bannerX, bannerY, bannerWidth, bannerHeight)]; // window to display on screen
  topWindow.windowLevel = UIWindowLevelStatusBar;
  topWindow.backgroundColor = [UIColor clearColor];
  [topWindow setUserInteractionEnabled:YES];
  [topWindow makeKeyAndVisible];
  topWindow.hidden = YES;

  mainView = [[UIView alloc] initWithFrame:CGRectMake(bannerX, bannerY, bannerWidth, bannerHeight)]; // top level view for everything else
  [mainView setBackgroundColor:_color];
  [mainView setUserInteractionEnabled:YES];
  [topWindow addSubview:mainView];

  if(_drop) { // create drop shadow then add it to the mainView
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:mainView.bounds];
    mainView.layer.masksToBounds = NO;
    mainView.layer.shadowColor = [UIColor blackColor].CGColor;
    mainView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    mainView.layer.shadowOpacity = 0.5f;
    mainView.layer.shadowPath = shadowPath.CGPath;
  }

  if(_blur) { // create blur view and add to mainView
    [mainView setBackgroundColor:[UIColor clearColor]];

    blurSettings = [_UIBackdropViewSettings settingsForStyle:_blurStyle]; // 0 = light, 2 = default, 1 = dark
    blurView = [[_UIBackdropView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, bannerHeight) autosizesToFitSuperview:YES settings:blurSettings];
    // [blurView setBlurRadiusSetOnce:NO];
    [blurView setBlurRadius:10.0];
    // [blurView setBlurHardEdges:2];
    // [blurView setBlursWithHardEdges:YES];
    [blurView setBlurQuality:@"default"];
    [mainView addSubview:blurView];
    [blurView release];
  }

  if([_view mode] == 1) { // view mode 1 is ringer, 0 is player
    ringerSlider = [[UISlider alloc] initWithFrame:CGRectMake(sliderX, sliderY, sliderWidth, sliderHeight)];
    ringerSlider.continuous = YES;

    CGFloat ringerVolume = 0;
    AVSystemController *controller = [NSClassFromString(@"AVSystemController") sharedAVSystemController];
    [controller getVolume:&ringerVolume forCategory:@"Ringtone"];
    ringerSlider.value = ringerVolume;

    //ringerSlider.value = [[NSClassFromString(@"VolumeControl") sharedVolumeControl] volume];
    ringerSlider.minimumValue = 0;
    ringerSlider.maximumValue = 1.0;
    [ringerSlider addTarget:self action:@selector(ringerSliderAction:) forControlEvents:UIControlEventValueChanged];
    [ringerSlider setBackgroundColor:[UIColor clearColor]];
    [ringerSlider setUserInteractionEnabled:_userInteraction];
    if(_statusBar) { // add no thumb image
      [ringerSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ringerChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [mainView addSubview:ringerSlider];
  } else {
    volumeSlider = [[GMPVolumeView alloc] initWithFrame:CGRectMake(sliderX, sliderY, sliderWidth, sliderHeight)];
    [volumeSlider setBackgroundColor:[UIColor clearColor]];
    [volumeSlider setUserInteractionEnabled:_userInteraction];
    volumeSlider.showsRouteButton = (_showRouteButton && !_statusBar);
    if(_statusBar) { // add no thumb image
      [volumeSlider setVolumeThumbImage:thumbImage forState:UIControlStateNormal];
    }
    [mainView addSubview:volumeSlider];
  }

  if(_slide && !_statusBar) { // set up swipe handler and create handle view, add to mainView
    handle = [[UIView alloc] initWithFrame:CGRectMake((screenWidth / 2) - 16, bannerHeight - 10, 32, 8)];
    [handle setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    handle.layer.cornerRadius = 4;
    handle.layer.masksToBounds = YES;
    [mainView addSubview:handle];
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
  }

  if(_label && !_statusBar) { // add label depending on mode, add to mainView
    label = [[UILabel alloc] initWithFrame:CGRectMake(bannerX, bannerY + 2, bannerWidth, sliderY)];
    [label setBackgroundColor:[UIColor clearColor]];
    label.text = [_view mode] == 1 ? @"Ringer" : @"Player";
    label.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]; // TODO: make text white when needed for contrast
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    [mainView addSubview:label];
    [label release];
  }

  mainView.frame = CGRectMake(bannerX, (-1 * bannerHeight) - 5, bannerWidth, bannerHeight); // hide frame for animation in

  [self adjustViewsForOrientation:[[UIDevice currentDevice] orientation] animated:NO];
  [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];

  _alive = YES;
}

-(void)destroyHUD { // release all allocated objects when done with banner
  HBLogDebug(@"destroyHUD called");
  [volumeSlider release];
  [swipeRecognizer release];
  [handle release];
  [mainView release];
  [topWindow release];
  _alive = NO;
}

-(void)showHUD { // animate banner in, set up gestures to work
  HBLogDebug(@"showHUD called");
  topWindow.hidden = NO;
  if(_animate) {
    [UIView animateWithDuration:_speed
	    delay:0
	    options:(UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction)
	    animations:^ {
	      mainView.frame = CGRectMake(bannerX, bannerY, bannerWidth, bannerHeight);
	    }
	    completion:^(BOOL finished) {
	    }
    ];
  } else {
    mainView.frame = CGRectMake(bannerX, bannerY, bannerWidth, bannerHeight);
  }

  if(_slide && !_statusBar) {
    [handle addGestureRecognizer:swipeRecognizer];
    [mainView addGestureRecognizer:swipeRecognizer];
  }
}

-(void)hideHUD { // animate gestures out, remove gestures, call destroyHUD
  HBLogDebug(@"hideHUD called");
  if(_slide && !_statusBar) {
    [handle removeGestureRecognizer:swipeRecognizer];
    [mainView removeGestureRecognizer:swipeRecognizer];
  }

  if(_animate) {
    [UIView animateWithDuration:_speed
	    delay:0
	    options:(UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction)
	    animations:^ {
	      mainView.frame = CGRectMake(bannerX, (-1 * bannerHeight) - 5, bannerWidth, bannerHeight);
	    }
	    completion:^(BOOL finished) {
	      [mainView removeFromSuperview];
	      topWindow.hidden = YES;
	      [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
	      [self destroyHUD];
	    }
    ];
  } else {
    mainView.frame = CGRectMake(bannerX, (-1 * bannerHeight) - 5, bannerWidth, bannerHeight);
    [mainView removeFromSuperview];
    topWindow.hidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    [self destroyHUD];
  }
}

-(void)loadHUDWithView:(id)view { // only method called from Tweak.xm, calls all other methods for setup and hiding
  HBLogDebug(@"loadHUDWithView called with view: %@", view);
  if(!_alive) {
    _view = view;
    [self createHUD];
    [self showHUD];

    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:_delayTime];
  }
}

@end
