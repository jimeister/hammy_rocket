//
//  YKEnemyNode.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKEnemyNode.h"
#import "YKHammyRocket.h"
#import "CPMath.h"

NSString *const YKEnemyNodeName = @"YKEnemyNodeName";

@implementation YKEnemyNode

- (instancetype)init {
  if ((self = [super init])) {
    self.name = YKEnemyNodeName;
    _timeAlive = 0.0;
    _health = 2;
    _score = 100;
    _ammoSpeed = 100;
  }
  return self;
}

- (YKEnemyAmmo *)ammo {
  return nil;
}

- (YKPowerUp *)powerUp {
  return nil;
}

- (void)fireAtPlayer {
  YKEnemyAmmo *ammo = [[YKEnemyAmmo alloc] init];
  ammo.position = self.position;
  ammo.zPosition = self.zPosition - 1;
  
  SKNode *playerNode = [self.scene childNodeWithName:YKHammyRocketNodeName];
  if (playerNode) {
    CGVector difference = CPCGVectorFromPoints(self.position, playerNode.position);
    CGFloat magnitude = CPCGVectorMagnitude(difference);
    ammo.velocity = CGVectorMake(difference.dx * _ammoSpeed / magnitude, difference.dy * _ammoSpeed / magnitude);
  }
  
  [self.scene addChild:ammo];
}

- (void)update:(NSTimeInterval)diff {
  _timeAlive += diff;
}

- (void)die {
  
}

@end
