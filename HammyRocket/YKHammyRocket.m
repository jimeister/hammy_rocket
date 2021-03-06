//
//  YKHammyRocket.m
//  HammyRocket
//
//  Created by Jim Liu on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKHammyRocket.h"
#import "CPMath.h"
#import "CPSmokeEmitterNode.h"

#define MAX_HEALTH (2)

static NSString *const kDefaultFont = @"Courier";
NSString *const YKHammyRocketNodeName = @"YKHammyRocketNodeName";

@implementation YKHammyRocket

- (instancetype)init {
  if ((self = [super init])) {
    self.name = YKHammyRocketNodeName;
    [self _createHammyRocketNodes];
    _maxVelocity = 170.0;
    _health = MAX_HEALTH;
    _enableBonusAmmo = NO;
  }
  return self;
}

- (CGRect)damageFrame {
  return CGRectMake(self.position.x - self.rocket_interior.size.width/2, self.position.y - self.rocket_interior.size.height/2,
                    self.rocket_interior.size.width, self.rocket_interior.size.height);
}

- (CGFloat)hitRadius {
  return self.rocket_interior.size.width/2;
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
  
  self.smokeEmitter = [[CPSmokeEmitterNode alloc] init];
  self.smokeEmitter.zPosition = self.zPosition + 1;
  self.smokeEmitter.particleBirthRate = 0;
  self.smokeEmitter.emissionAngle = CPDegreesToRadian(270);
  self.smokeEmitter.targetNode = self.scene; // TODO why doesn't this work?
  [self addChild:self.smokeEmitter];
}

- (void)setHealth:(NSInteger)health {
  _health = health;
  if (health < MAX_HEALTH) {
    [self.smokeEmitter resetSimulation];
    self.smokeEmitter.particleBirthRate = 4.0;
  } else {
    self.smokeEmitter.particleBirthRate = 0.0;
  }
}

- (void)applyPowerUp:(YKPowerUp *)powerUp {
  SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:kDefaultFont];
  label.fontSize = 18.0;
  label.fontColor = [UIColor whiteColor];
  label.position = CGPointMake(0, 32.0);
  
  switch (powerUp.type) {
    case YKHealth:
    {
      self.health += powerUp.value;
      if (self.health > MAX_HEALTH) {
        self.health = MAX_HEALTH;
      }
      
      label.text = @"HEALTH UP!";
      [self addChild:label];
      [label runAction:[SKAction fadeAlphaTo:0.0 duration:1.0] completion:^(void) {
        [label removeFromParent];
      }];
      
      break;
    }
    case YKSpeed:
    {
      self.maxVelocity += powerUp.value;
      
      label.text = @"SPEED UP!";
      [self addChild:label];
      [label runAction:[SKAction fadeAlphaTo:0.0 duration:1.0] completion:^(void) {
        [label removeFromParent];
      }];
      
      break;
    }
    case YKAmmo:
    {
      self.enableBonusAmmo = YES;
      
      label.text = @"AMMO UP!";
      [self addChild:label];
      [label runAction:[SKAction fadeAlphaTo:0.0 duration:1.0] completion:^(void) {
        [label removeFromParent];
      }];
      
      break;
    }
    default:
      break;
  }
}

@end
