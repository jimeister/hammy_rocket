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

- (YKLevelEvent *)basicEnemyEvent {
  YKLevelEvent *event = [[YKLevelEvent alloc] init];
  event.enemies = @[
                    [YKLevelEnemyBirth enemyBirthWithNode:[[YKAirplaneNode alloc] initWithStyle:0] birthPlace:CGPointMake(30, 20)],
                    [YKLevelEnemyBirth enemyBirthWithNode:[[YKAirplaneNode alloc] initWithStyle:0] birthPlace:CGPointMake(90, 20)],
                    [YKLevelEnemyBirth enemyBirthWithNode:[[YKAirplaneNode alloc] initWithStyle:0] birthPlace:CGPointMake(150, 20)]
                    ];
  return event;
}

- (NSDictionary *)_gameEvents {
  return @{
           @(3) : [self basicEnemyEvent],
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
  
  NSInteger realTime = (NSInteger)(currentTime - _startTime) % 5;
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
