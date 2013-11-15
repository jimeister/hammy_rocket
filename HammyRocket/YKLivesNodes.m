//
//  YKLivesNodes.m
//  HammyRocket
//
//  Created by Jim Liu on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKLivesNodes.h"

@implementation YKLivesNodes

- (instancetype)initWithMaxLives:(NSInteger)lives {
  if ((self = [super init])) {
    _numLives = lives;
    [self _createLifeNodes];
  }
  return self;
}

- (void)_createLifeNodes {
  for (NSInteger i = 0; i < _numLives; i++) {
    SKSpriteNode *rocket = [SKSpriteNode spriteNodeWithImageNamed:@"rocket.png"];
    rocket.position = CGPointMake(40 * i, 0);
    rocket.size = CGSizeMake(35, 35);
    [self addChild:rocket];
  }
}

- (void)decrementLife {
  if (self.numLives > 0) {
    _numLives--;
  }
}

@end
