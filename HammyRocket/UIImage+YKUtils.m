//
//  UIImage+YKUtils.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "UIImage+YKUtils.h"

@implementation UIImage (YKUtils)

- (UIImage *)yk_imageByCroppingWithRect:(CGRect)rect {
  CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
  UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
  CGImageRelease(imageRef);
  return croppedImage;
}

@end
