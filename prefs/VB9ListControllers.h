/*
 * VB9ListControllers.h
 * VolumeBar9
 *
 * Created by cgm616
 * Copyright (c) 2016 cgm616. All rights reserved.
 */

#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <libcolorpicker.h>
#import <UIKit/UIKit.h>
#import <FrontBoard/FBSystemService.h>

@interface VB9RootListController : PSListController

@end

@interface VB9ChildListController : PSListController

@end

@interface VB9ChildAboutListController : VB9ChildListController

@end

@interface VB9ChildAnimateListController : VB9ChildListController

@end

@interface VB9ChildBannerListController : VB9ChildListController

@end

@interface VB9ChildCreditListController : VB9ChildListController

@end
