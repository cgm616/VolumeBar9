// https://gist.github.com/tomasbasham/10533743
// https://stackoverflow.com/questions/5084845/how-to-set-the-opacity-alpha-of-a-uiimage
// https://stackoverflow.com/questions/6672517/is-programmatically-inverting-the-colors-of-an-image-possible

#import <CoreImage/CoreImage.h>

@implementation UIImage (scale)

/**
 * Scales an image to fit within a bounds with a size governed by
 * the passed size. Also keeps the aspect ratio.
 *
 * Switch MIN to MAX for aspect fill instead of fit.
 *
 * @param newSize the size of the bounds the image must fit within.
 * @return a new scaled image.
 */
- (UIImage *)scaleImageToSize:(CGSize)newSize alpha:(CGFloat)alpha {
  CGRect scaledImageRect = CGRectZero;

  CGFloat aspectWidth = newSize.width / self.size.width;
  CGFloat aspectHeight = newSize.height / self.size.height;
  CGFloat aspectRatio = MIN ( aspectWidth, aspectHeight );

  scaledImageRect.size.width = self.size.width * aspectRatio;
  scaledImageRect.size.height = self.size.height * aspectRatio;
  scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0f;
  scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0f;

  UIGraphicsBeginImageContextWithOptions( newSize, NO, 0 );
  [self drawInRect:scaledImageRect blendMode:kCGBlendModeNormal alpha:alpha];
  UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return scaledImage;

}

- (UIImage *)invertImage {
  CIImage *coreImage = [CIImage imageWithCGImage:self.CGImage];
  CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
  [filter setValue:coreImage forKey:kCIInputImageKey];
  CIImage *result = [filter valueForKey:kCIOutputImageKey];
  return [UIImage imageWithCIImage:result scale:self.scale orientation:self.imageOrientation];
}

@end
