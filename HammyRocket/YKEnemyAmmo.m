//
//  YKEnemyAmmo.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKEnemyAmmo.h"
#import "UIImage+YKUtils.h"

NSString *const YKEnemyAmmoName = @"YKEnemyAmmoName";

@implementation YKEnemyAmmo

- (instancetype)init {
  if ((self = [super initWithTexture:[SKTexture textureWithImage:[[self class] singleAmmoImage]]])) {
    self.size = CGSizeMake(18, 18);
    self.name = YKEnemyAmmoName;
  }
  return self;
}

+ (UIImage *)singleAmmoImage {
  static UIImage *image = nil;
  if (!image) {
    UIImage *template = [UIImage imageNamed:@"1945.png"];
    image = [template yk_imageByCroppingWithRect:CGRectMake(4 + 33*8 + 10, 4 + 33*3 + 10, 13, 13)];
  }
  return image;
}

@end
