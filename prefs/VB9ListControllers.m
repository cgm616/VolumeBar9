/*
 * VB9ListControllers.m
 * VolumeBar9
 *
 * Created by cgm616
 * Copyright (c) 2016 cgm616. All rights reserved.
 */

#include "VB9ListControllers.h"

extern char **environ;
static BOOL settingsChanged;

@implementation VB9RootListController

-(NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

-(void)respring {
  // TODO: make tweak not require respring
  HBLogDebug(@"respringing");
  [[NSClassFromString(@"FBSystemService") sharedInstance] exitAndRelaunch:YES];
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier *)spec {
	[super setPreferenceValue:value specifier:spec];
	if (!settingsChanged) {
		settingsChanged = YES;
    [self settingsChanged];
	}
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

	if(settingsChanged) {
		[self settingsChanged];
	}
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

-(void)settingsChanged {
  HBLogDebug(@"Settings changed, button would change here")
  UIBarButtonItem *respringButton = ([[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStyleDone target:self action:@selector(respring)]);
  [[self navigationItem] setLeftBarButtonItem:respringButton];
  [respringButton release];
}


@end

@implementation VB9ChildListController

-(void)githubButton:(PSSpecifier *)spec {
  HBLogDebug(@"Github button pushed with name: %@", spec.name);

  NSString *user = [spec.name stringByReplacingOccurrencesOfString:@" on GitHub" withString:@""];

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://github.com/" stringByAppendingString:user]]];
}

-(void)twitterButton:(PSSpecifier *)spec {
  HBLogDebug(@"Twitter button pushed with name: %@", spec.name);

  NSString *user = [spec.name substringFromIndex:1];

  if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];

  else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:user]]];

  else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]]];

  else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];

  else
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier *)spec {
	[super setPreferenceValue:value specifier:spec];
	if (!settingsChanged) {
		settingsChanged = YES;
	}
}

@end

@implementation VB9ChildAboutListController

-(NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"About" target:self] retain];
	}

	return _specifiers;
}

@end

@implementation VB9ChildAnimateListController

-(NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Animate" target:self] retain];
	}

	return _specifiers;
}

@end

@implementation VB9ChildBannerListController

// TODO: fix the weird updating problem with the color picker.
// The color read by the tweak is saved, but doesn't update until another
// setting is changed.

-(NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Banner" target:self] retain];
	}

	return _specifiers;
}

-(void)libColorPicker {
  CFPropertyListRef color = CFPreferencesCopyAppValue(CFSTR("bannercolor"), CFSTR("me.cgm616.volumebar9"));

  if(!color) {
    HBLogError(@"Error getting color value from prefs, using fallback");
  }

  UIColor *startColor = LCPParseColorString((NSString*)color, @"#FFFFFF");

  PFColorAlert *alert = [PFColorAlert colorAlertWithStartColor:startColor showAlpha:YES];

  [alert displayWithCompletion:
    ^void (UIColor *pickedColor){
      NSString *hexString = [UIColor hexFromColor:pickedColor];
      hexString = [hexString stringByAppendingFormat:@":%g", pickedColor.alpha];

      CFPreferencesSetAppValue(CFSTR("bannercolor"), hexString, CFSTR("me.cgm616.volumebar9"));
      CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.cgm616.volumebar9/preferences.changed"), NULL, NULL, false);

      settingsChanged = YES;
    }
  ];
}

@end

@implementation VB9ChildCreditListController

-(NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Credit" target:self] retain];
	}

	return _specifiers;
}

@end
