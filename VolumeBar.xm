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
@synthesize sliderColorEnabled = _sliderColorEnabled;
@synthesize maxColor = _maxColor;
@synthesize minColor = _minColor;
@synthesize animate = _animate;
@synthesize userInteraction = _userInteraction;
@synthesize showRouteButton = _showRouteButton;
@synthesize blur = _blur;
@synthesize drop = _drop;
@synthesize icon = _icon;
@synthesize adaptive = _adaptive;
@synthesize statusBarForegroundColor = _statusBarForegroundColor;
@synthesize statusBar = _statusBar;
@synthesize gesture = _gesture;
@synthesize slideHandle = _slideHandle;
@synthesize label = _label;
@synthesize delayTime = _delayTime;
@synthesize speed = _speed;
@synthesize height = _height;
@synthesize blurStyle = _blurStyle;
@synthesize gestureType = _gestureType;
@synthesize statusBrightness = _statusBrightness;
@synthesize completion = _completion;

-(void)resetTimer {
  if(hide != nil) {
    [hide invalidate];
    hide = nil;
    hide = [NSTimer scheduledTimerWithTimeInterval:_delayTime target:self selector:@selector(_hideHUD) userInfo:nil repeats:NO];
  }
}

-(void)_swipeHandler:(UITapGestureRecognizer *)gestureRecognizer { // stops hide timer and calls _hideHUD when swiped
  if(hide != nil) {
    [hide invalidate];
    hide = nil;
  }

  [self _hideHUD];
}

-(void)adjustViewsForOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animateOrient {
  CGPoint windowCenter;
  CGAffineTransform transform;
  CGRect bounds = topWindow.bounds;

  switch (orientation) {
    case UIInterfaceOrientationPortraitUpsideDown:
    {
      transform = CGAffineTransformMakeRotation(M_PI);
      bounds.size.width = screenWidth;
      windowCenter = CGPointMake(screenWidth / 2, screenHeight - (bannerHeight / 2));
    } break;

    case UIInterfaceOrientationLandscapeLeft:
    {
      transform = CGAffineTransformMakeRotation(M_PI / -2);
      bounds.size.width = screenHeight;
      windowCenter = CGPointMake(bannerHeight / 2, screenHeight / 2);
    } break;

    case UIInterfaceOrientationLandscapeRight:
    {
      transform = CGAffineTransformMakeRotation(M_PI / 2);
      bounds.size.width = screenHeight;
      windowCenter = CGPointMake(screenWidth - (bannerHeight / 2), screenHeight / 2);
    } break;

    case UIInterfaceOrientationUnknown:
    case UIInterfaceOrientationPortrait:
    default:
    {
      transform = CGAffineTransformMakeRotation(0);
      bounds.size.width = screenWidth;
      windowCenter = CGPointMake(screenWidth / 2, bannerHeight / 2);
    } break;
  }

  if(animateOrient) {
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
      [topWindow setTransform:transform];
      topWindow.bounds = bounds;
      topWindow.center = windowCenter;
    } completion:nil];
  } else {
    [topWindow setTransform:transform];
    topWindow.bounds = bounds;
    topWindow.center = windowCenter;
  }
}

-(void)_calculateRender { // does frame calculations and creates thumbImage
  CGSize screenSize = [[UIScreen mainScreen] bounds].size;
  screenSize = CGSizeMake(MIN(screenSize.width, screenSize.height), MAX(screenSize.width, screenSize.height));
  screenWidth = screenSize.width;
  screenHeight = screenSize.height;

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

  if(_slideHandle && !_statusBar) {
    bannerHeight = bannerHeight + 12;
  }

  if(_label && !_statusBar) {
    sliderY = sliderY + 14;
    bannerHeight = bannerHeight + sliderY;
  }
}

-(void)_createHUD { // creates view heirarchy
  [self _calculateRender];

  topWindow = [[UIWindow alloc] initWithFrame:CGRectMake(bannerX, bannerY, bannerWidth, bannerHeight)]; // window to display on screen
  topWindow.windowLevel = UIWindowLevelStatusBar + 100;
  topWindow.backgroundColor = [UIColor clearColor];
  [topWindow setUserInteractionEnabled:YES];
  [topWindow makeKeyAndVisible];
  topWindow.hidden = YES;

  mainView = [[UIView alloc] initWithFrame:CGRectMake(bannerX, bannerY, bannerWidth, bannerHeight)]; // top level view for everything else
  [mainView setBackgroundColor:_color];
  [mainView setUserInteractionEnabled:YES];
  mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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
    [blurView setBlurRadius:10.0];
    [blurView setBlurQuality:@"default"];
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [mainView addSubview:blurView];
    [blurView release];
  }

  volumeSlider = [[GMPVolumeView alloc] initWithFrame:CGRectMake(sliderX, sliderY, sliderWidth, sliderHeight)];
  [volumeSlider setBackgroundColor:[UIColor clearColor]];
  [volumeSlider setUserInteractionEnabled:_userInteraction];
  volumeSlider.showsRouteButton = (_showRouteButton && !_statusBar);
  if(_statusBar) { // add no thumb image
    [volumeSlider setVolumeThumbImage:thumbImage forState:UIControlStateNormal];
  }
  if(_sliderColorEnabled) {
    if(_adaptive) {
      [[volumeSlider volumeSlider] setMinimumTrackTintColor:_statusBarForegroundColor];
    } else {
      [[volumeSlider volumeSlider] setMinimumTrackTintColor:_minColor];
    }
    [[volumeSlider volumeSlider] setMaximumTrackTintColor:_maxColor];
  }
  
  volumeSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth;

  UIImage *minimum;
  UIImage *maximum;
  CGSize minSize;
  CGSize maxSize = CGSizeMake(16, 16);

  if([_view mode] == 1) {
    [[volumeSlider volumeSlider] setVolumeAudioCategory:@"Ringtone"];
    minimum = [UIImage imageNamed:@"ringerMinimum" inBundle:_bundle compatibleWithTraitCollection:nil];
    maximum = [UIImage imageNamed:@"ringerMaximum" inBundle:_bundle compatibleWithTraitCollection:nil];
    minSize = maxSize;
  } else {
    [[volumeSlider volumeSlider] setVolumeAudioCategory:@"Audio/Video"];
    minimum = [UIImage imageNamed:@"playerMinimum" inBundle:_bundle compatibleWithTraitCollection:nil];
    maximum = [UIImage imageNamed:@"playerMaximum" inBundle:_bundle compatibleWithTraitCollection:nil];
    minSize = CGSizeMake(14, 14);
  }

  BOOL bannerBackgroundBright = NO;
  if(!_blur) {
    CGFloat hue, saturation, brightness, alpha;
    [_color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    bannerBackgroundBright = (brightness * alpha) > 0.5;
  }
  BOOL statusForegroundBright = _statusBrightness > 0.5;
  CGFloat brightness;
  if(statusForegroundBright && !(bannerBackgroundBright && !_blur)) {
    brightness = 1.0;
    minimum = [minimum invertImage];
    maximum = [maximum invertImage];
  } else {
    brightness = 0.0;
  }

  if(_icon) {
    [volumeSlider volumeSlider].minimumValueImage = [minimum scaleImageToSize:minSize alpha:1.0];
    [volumeSlider volumeSlider].maximumValueImage = [maximum scaleImageToSize:maxSize alpha:1.0];
  }

  if(_showRouteButton) {
    UIButton *routeButton = [volumeSlider _routeButton];
    UIImage *routeImage = [routeButton imageForState:UIControlStateNormal];
    [routeButton setImage:[routeImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    routeButton.tintColor = [UIColor colorWithRed:brightness green:brightness blue:brightness alpha:1.0];
  }

  [mainView addSubview:volumeSlider];

  if(_slideHandle && !_statusBar) { // set up swipe handler and create handle view, add to mainView
    handle = [[UIView alloc] initWithFrame:CGRectMake((screenWidth / 2) - 16, bannerHeight - 10, 32, 8)];
    [handle setBackgroundColor:[UIColor colorWithRed:brightness green:brightness blue:brightness alpha:1.0]];
    handle.layer.cornerRadius = 4;
    handle.layer.masksToBounds = YES;
    [mainView addSubview:handle];
  }

  if(_label && !_statusBar) { // add label depending on mode, add to mainView
    label = [[UILabel alloc] initWithFrame:CGRectMake(bannerX, bannerY + 2, bannerWidth, sliderY)];
    [label setBackgroundColor:[UIColor clearColor]];
    label.text = [_view mode] == 1 ? @"Ringer" : @"Player";
    label.textColor = [UIColor colorWithRed:brightness green:brightness blue:brightness alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    [mainView addSubview:label];
    [label release];
  }

  mainView.frame = CGRectMake(bannerX, (-1 * bannerHeight) - 5, bannerWidth, bannerHeight); // hide frame for animation in
}

-(void)_addGestureToView:(UIView *)view {
  switch (_gestureType) {
    case VB9GestureTypeSlide:
    {
      UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_swipeHandler:)];
      [gesture setDirection:UISwipeGestureRecognizerDirectionUp];
      [view addGestureRecognizer:gesture];
      [gesture release];
    } break;

    case VB9GestureTypeLongPress:
    {
      UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_swipeHandler:)];
      gesture.allowableMovement = 5.0;
      [view addGestureRecognizer:gesture];
      [gesture release];
    } break;

    case VB9GestureTypeTap:
    {
      UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_swipeHandler:)];
      [view addGestureRecognizer:gesture];
      [gesture release];
    } break;

    default:
    case VB9GestureTypeDoubleTap:
    {
      UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_swipeHandler:)];
      gesture.numberOfTapsRequired = 2;
      [view addGestureRecognizer:gesture];
      [gesture release];
    } break;
  }
}

-(void)_showHUD { // animate banner in, set up gestures to work
  topWindow.hidden = NO;

  if(_gesture) {
    [self _addGestureToView:topWindow];
    [self _addGestureToView:mainView];
    [self _addGestureToView:volumeSlider];
    if(_slideHandle) {
      [self _addGestureToView:handle];
    }
  }

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
}

-(void)_hideHUD { // animate gestures out, remove gestures
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
        if(_completion) {
          _completion();
        }
	    }
    ];
  } else {
    mainView.frame = CGRectMake(bannerX, (-1 * bannerHeight) - 5, bannerWidth, bannerHeight);
    [mainView removeFromSuperview];
    topWindow.hidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    if(_completion) {
      _completion();
    }
  }
}

-(void)dealloc {
  [volumeSlider release];
  if(_slideHandle) {
    [handle release];
  }
  [mainView release];
  [topWindow release];
  if(hide != nil) {
    hide = nil;
  }
  [super dealloc];
}

-(void)loadHUDView:(id)view orientation:(UIInterfaceOrientation)orientation { // only method called from Tweak.xm, calls all other methods for setup and hiding
  _view = view;
  _bundle = [NSBundle bundleWithPath:@"/Library/Application Support/VolumeBar9/VolumeBar9.bundle"];

  [self _createHUD];
  [self _showHUD];
  [self adjustViewsForOrientation:orientation animated:NO];

  hide = [NSTimer scheduledTimerWithTimeInterval:_delayTime target:self selector:@selector(_hideHUD) userInfo:nil repeats:NO];
}

@end
