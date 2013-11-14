//
//  YKLevelScheduler.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKLevelScheduler.h"
#import "YKAirplaneNode.h"

@implementation YKLevelScheduler {
  BOOL _started;
  NSTimeInterval _startTime;
  NSMutableDictionary *_currentGameEvents;
}

- (instancetype)init {
  if ((self = [super init])) {
    [self _resetEvents];
  }
  return self;
}

- (YKLevelEvent *)basicEnemyEventWithNumEnemies:(NSUInteger)numEnemies x:(CGFloat)x style:(NSInteger)style {
  YKLevelEvent *event = [[YKLevelEvent alloc] init];
  NSMutableArray *enemies = [NSMutableArray arrayWithCapacity:numEnemies];
  for (NSUInteger i = 0; i < numEnemies; ++i) {
    YKAirplaneNode *enemy = [[YKAirplaneNode alloc] initWithStyle:style];
    [enemies addObject:[YKLevelEnemyBirth enemyBirthWithNode:enemy birthPlace:CGPointMake(x + 60*i, 20)]];
  }
  event.enemies = enemies;
  return event;
}

- (NSDictionary *)_gameEvents {
  return @{
           @(3) : [self basicEnemyEventWithNumEnemies:3 x:30 style:0],
           @(6) : [self basicEnemyEventWithNumEnemies:6 x:80 style:3],
           };
}

- (void)_resetEvents {
  _currentGameEvents = [[self _gameEvents] mutableCopy];
}

- (YKLevelEvent *)eventForCurrentTime:(NSTimeInterval)currentTime {
  if (!_started) {
    _started = YES;
    _startTime = currentTime;
  }
  
  NSInteger realTime = (NSInteger)(currentTime - _startTime) % 10;
  if (realTime == 0) {
    [self _resetEvents];
  }
  
  if (_currentGameEvents[@(realTime)]) {
    YKLevelEvent *event = _currentGameEvents[@(realTime)];
    [_currentGameEvents removeObjectForKey:@(realTime)];
    return event;
  }
  
  return nil;
}

@end
