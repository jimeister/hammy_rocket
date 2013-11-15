//
//  YKMissile.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/15/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKMissile.h"
#import "UIImage+YKUtils.h"
#import "CPSimpleSpriteFactory.h"

@implementation YKMissile

- (instancetype)init {
  if ((self = [super init])) {
    self.bodyTexture = [SKTexture textureWithImage:[[self class] rocketBodyImage]];
    [self setBodySize:CGSizeMake(22, 46)];
    self.exhaustParticleTexture = [SKTexture textureWithImage:[CPSimpleSpriteFactory circleImageWithDiameter:12 fillColor:[UIColor whiteColor] strokeColor:[UIColor whiteColor]]];
    self.exhaustParticleLifetime = 1.0;
    self.name = @"Missile";
    self.zPosition = -3;
    _acceleration = 50.0;
    _yVelocity = 0;
  }
  return self;
}

+ (UIImage *)rocketBodyImage {
  static UIImage *image = nil;
  if (!image) {
    UIImage *template = [UIImage imageNamed:@"1945.png"];
    image = [template yk_imageByCroppingWithRect:CGRectMake(279, 272, 11, 23)];
  }
  return image;
}

@end
