//
//  YKWaterBackgroundLayer.m
//  HammyRocket
//
//  Created by Jim Liu on 11/15/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKWaterBackgroundLayer.h"

@implementation YKWaterBackgroundLayer {
  CGFloat _speed;
}

- (instancetype)init {
  if ((self = [super init])) {
    _speed = 50;
    [self _createInitialWater];
    self.zPosition = -500;
  }
  return self;
}

- (void)_createInitialWater {
  for (NSInteger i = 0; i < 5; i++) {
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"oceantile.png"];
    node.position = CGPointMake(0, 2048 - i * 576);
    node.size = CGSizeMake(1536, 576);
    node.name = @"Water";
    node.alpha = 0.3;
    [self addChild:node];
  }
}

- (void)update:(NSTimeInterval)diff {
  [self enumerateChildNodesWithName:@"Water" usingBlock:^(SKNode *node, BOOL *stop) {
    node.position = CGPointMake(node.position.x, node.position.y - _speed * diff);
    if (node.position.y < 2048 - 576 * 5) {
      node.position = CGPointMake(0, 2048);
    }
  }];
}

@end
