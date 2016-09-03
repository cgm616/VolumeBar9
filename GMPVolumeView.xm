/*
 * Tweak.xm
 * VolumeBar9
 *
 * Created by cgm616
 * Copyright (c) 2016 cgm616. All rights reserved.
 */

#import "GMPVolumeView.h"

@implementation GMPVolumeView // new implementation of MPVolumeView to fix positioning issues

-(CGRect)volumeSliderRectForBounds:(CGRect)bounds {
  CGRect newBounds=[super volumeSliderRectForBounds:bounds];
  newBounds.origin.y=bounds.origin.y;
  newBounds.size.height=bounds.size.height;
  return newBounds;
}

-(CGRect)routeButtonRectForBounds:(CGRect)bounds {
  CGRect newBounds=[super routeButtonRectForBounds:bounds];
  newBounds.origin.y=bounds.origin.y;
  newBounds.size.height=bounds.size.height;
  return newBounds;
}

-(void)layoutSubviews {
  [super layoutSubviews];
  [self recursiveRemoveAnimationsOnView:self];
}

-(void)recursiveRemoveAnimationsOnView:(UIView *)view {
  [view.layer removeAllAnimations];
  for (UIView *subview in view.subviews) {
    [self recursiveRemoveAnimationsOnView:subview];
  }
}

@end
