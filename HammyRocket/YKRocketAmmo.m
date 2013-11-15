//
//  YKRocketAmmo.m
//  HammyRocket
//
//  Created by Jim Liu on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKRocketAmmo.h"
#import "UIImage+YKUtils.h"

NSString *const YKAmmoName = @"YKAmmoName";

@implementation YKAmmoSprite
@end

@interface YKRocketAmmo ()
@property (nonatomic) CGFloat fireRate;
@end

@implementation YKRocketAmmo

- (instancetype)initWithFireRate:(CGFloat)rate {
  if ((self = [super init])) {
    _fireRate = rate;
    _ammoVelocity = 500.0;
    _damage = 1;
  }
  return self;
}

+ (UIImage *)singleAmmoImage {
  static UIImage *image = nil;
  if (!image) {
    UIImage *template = [UIImage imageNamed:@"1945.png"];
    image = [template yk_imageByCroppingWithRect:CGRectMake(4 + 33 + 11, 4 + 33*5 + 7, 9, 20)];
  }
  return image;
}

- (void)createFireAction {
  self.fire = [SKAction sequence: @[
                                    [SKAction performSelector:@selector(_createAmmo) onTarget:self],
                                    [SKAction waitForDuration:self.fireRate]
                                    ]];
}

- (void)_createAmmo {
  YKAmmoSprite *ammo = [[YKAmmoSprite alloc] initWithTexture:[SKTexture textureWithImage:[[self class] singleAmmoImage]]];
  ammo.position = CGPointMake(0, 0);
  ammo.name = YKAmmoName;
  ammo.ammoDirection = CGVectorMake(0, _ammoVelocity);
  [self addChild:ammo];
  
  if (self.upgradeAmmo) {
    self.fireRate = 0.10;
    YKAmmoSprite *leftAmmo = [[YKAmmoSprite alloc] initWithTexture:[SKTexture textureWithImage:[[self class] singleAmmoImage]]];
    leftAmmo.position = CGPointMake(0, 0);
    leftAmmo.name = YKAmmoName;
    leftAmmo.ammoDirection = CGVectorMake(-80, _ammoVelocity);
    [self addChild:leftAmmo];
    
    YKAmmoSprite *rightAmmo = [[YKAmmoSprite alloc] initWithTexture:[SKTexture textureWithImage:[[self class] singleAmmoImage]]];
    rightAmmo.position = CGPointMake(0, 0);
    rightAmmo.name = YKAmmoName;
    rightAmmo.ammoDirection = CGVectorMake(80, _ammoVelocity);
    [self addChild:rightAmmo];
  }
}

@end
