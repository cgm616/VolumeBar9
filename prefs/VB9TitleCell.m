/*
 * VB9TitleCell.m
 * VolumeBar9
 *
 * Created by cgm616
 * Copyright (c) 2016 cgm616. All rights reserved.
 */

#import "VB9TitleCell.h"

@implementation VB9TitleCell

-(id)initWithSpecifier:(PSSpecifier *)specifier {
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];

  if(self) {
		int width = [[UIScreen mainScreen] bounds].size.width;

		CGRect frame = CGRectMake(0, -30, width, 60);
		CGRect subtitleFrame = CGRectMake(0, 5, width, 60);

		tweakTitle = [[UILabel alloc] initWithFrame:frame];
		[tweakTitle setNumberOfLines:1];
		[tweakTitle setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:48]];
		[tweakTitle setText:@"VolumeBar9"];
		[tweakTitle setBackgroundColor:[UIColor clearColor]];
		[tweakTitle setTextColor:[UIColor blackColor]];
		[tweakTitle setTextAlignment:NSTextAlignmentCenter];

		tweakSubtitle = [[UILabel alloc] initWithFrame:subtitleFrame];
		[tweakSubtitle setNumberOfLines:1];
		[tweakSubtitle setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:25]];
		[tweakSubtitle setText:@"By cgm616"];
		[tweakSubtitle setBackgroundColor:[UIColor clearColor]];
		[tweakSubtitle setTextColor:[UIColor blackColor]];
		[tweakSubtitle setTextAlignment:NSTextAlignmentCenter];

		[self addSubview:tweakTitle];
		[self addSubview:tweakSubtitle];
  }

  return self;
}

@end
