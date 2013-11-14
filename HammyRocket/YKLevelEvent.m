//
//  YKLevelEvent.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKLevelEvent.h"

@implementation YKLevelEnemyBirth

- (instancetype)initWithNode:(YKEnemyNode *)node birthPlace:(CGPoint)birthPlace {
  if ((self = [super init])) {
    _enemyNode = node;
    _birthPlace = birthPlace;
  }
  return self;
}

+ (YKLevelEnemyBirth *)enemyBirthWithNode:(YKEnemyNode *)node birthPlace:(CGPoint)birthPlace {
  return [[YKLevelEnemyBirth alloc] initWithNode:node birthPlace:birthPlace];
}


@end

@implementation YKLevelEvent



@end
