//
//  YKHammyRocket.m
//  HammyRocket
//
//  Created by Jim Liu on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKHammyRocket.h"

@implementation YKHammyRocket

- (instancetype)init {
  if ((self = [super init])) {
    [self _createHammyRocketNodes];
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
}

@end
