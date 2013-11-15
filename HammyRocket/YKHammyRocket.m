//
//  YKHammyRocket.m
//  HammyRocket
//
//  Created by Jim Liu on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKHammyRocket.h"
#import "YKPowerUp.h"

#define MAX_HEALTH  500.0

@implementation YKHammyRocket

- (instancetype)init {
  if ((self = [super init])) {
    [self _createHammyRocketNodes];
    _maxVelocity = 150.0;
    _health = MAX_HEALTH;
  }
  return self;
}

- (void)_createHammyRocketNodes {
  self.rocket = [SKSpriteNode spriteNodeWithImageNamed:@"rocket.png"];
  self.rocket.position = CGPointMake(0, 0);
  [self addChild:self.rocket];
  
  self.hammy = [SKSpriteNode spriteNodeWithImageNamed:@"hammy.png"];
  self.hammy.position = CGPointMake(0, -10.0);
  self.hammy.zPosition = self.rocket.zPosition - 1;
  [self addChild:self.hammy];
  
  self.rocket_interior = [SKSpriteNode spriteNodeWithImageNamed:@"rocket_interior.png"];
  self.rocket_interior.position = CGPointMake(0, 0);
  self.rocket_interior.zPosition = self.hammy.zPosition - 1;
  [self addChild:self.rocket_interior];
  
  self.flame = [SKSpriteNode spriteNodeWithImageNamed:@"flame.png"];
  self.flame.position = CGPointMake(0, -35.0);
  self.flame.zPosition = self.rocket_interior.zPosition - 1;
  [self addChild:self.flame];
}

- (void)applyPowerUp:(YKPowerUp *)powerUp {
  switch (powerUp.type) {
    case YKHealth:
      self.health += powerUp.value;
      if (self.health > MAX_HEALTH) {
        self.health = MAX_HEALTH;
      }
      break;
    case YKSpeed:
      self.maxVelocity = powerUp.value;
      break;
    default:
      break;
  }
}

@end
