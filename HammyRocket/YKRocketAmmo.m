//
//  YKRocketAmmo.m
//  HammyRocket
//
//  Created by Jim Liu on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKRocketAmmo.h"

@interface YKRocketAmmo ()
@property (nonatomic) CGFloat fireRate;
@end

@implementation YKRocketAmmo

- (instancetype)initWithFireRate:(CGFloat)rate {
  if ((self = [super init])) {
    _fireRate = rate;
    _ammoVelocity = 500.0;
  }
  return self;
}

- (void)createFireAction {
  self.fire = [SKAction sequence: @[
                                    [SKAction performSelector:@selector(_createAmmo) onTarget:self],
                                    [SKAction waitForDuration:self.fireRate]
                                    ]];
}

- (void)_createAmmo {
  SKSpriteNode *ammo = [[SKSpriteNode alloc] initWithColor:[SKColor whiteColor] size:CGSizeMake(2,5)];
  ammo.position = CGPointMake(0, 0);
  ammo.name = @"ammo";
  [self addChild:ammo];
}

@end
