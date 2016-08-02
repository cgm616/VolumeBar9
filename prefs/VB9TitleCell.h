/*
 * VB9TitleCell.h
 * VolumeBar9
 *
 * Created by cgm616
 * Copyright (c) 2016 cgm616. All rights reserved.
 */

#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>

@protocol PreferencesTableCustomView
- (id)initWithSpecifier:(id)arg1;

@optional
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1;
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 inTableView:(id)arg2;
@end

@interface PSTableCell ()
- (id)initWithStyle:(int)style reuseIdentifier:(id)arg2;
@end

@interface VB9TitleCell : PSTableCell <PreferencesTableCustomView> {
    UILabel *tweakTitle;
    UILabel *tweakSubtitle;
}

@end
