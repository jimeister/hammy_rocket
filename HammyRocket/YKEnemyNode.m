//
//  YKEnemyNode.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKEnemyNode.h"

NSString *const YKEnemyNodeName = @"YKEnemyNodeName";

@implementation YKEnemyNode

- (instancetype)init {
  if ((self = [super init])) {
    self.name = YKEnemyNodeName;
    _timeAlive = 0.0;
    _health = 2;
    _score = 100;
  }
  return self;
}

- (YKEnemyAmmo *)ammo {
  return nil;
}

- (YKPowerUp *)powerUp {
  return nil;
}

- (void)update:(NSTimeInterval)diff {
  _timeAlive += diff;
}

@end
