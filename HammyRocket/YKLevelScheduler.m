//
//  YKLevelScheduler.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKLevelScheduler.h"
#import "YKAirplaneNode.h"
#import "YKPowerUp.h"

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

// Enemies fly down shoot, and then leave
- (YKLevelEvent *)basicEnemyEventWithNumEnemies:(NSUInteger)numEnemies x:(CGFloat)x style:(NSInteger)style {
  YKLevelEvent *event = [[YKLevelEvent alloc] init];
  NSMutableArray *enemies = [NSMutableArray arrayWithCapacity:numEnemies];
  for (NSUInteger i = 0; i < numEnemies; ++i) {
    YKAirplaneNode *enemy = [[YKAirplaneNode alloc] initWithStyle:style];
    [enemy turnDown];
    [enemies addObject:[YKLevelEnemyBirth enemyBirthWithNode:enemy birthPlace:CGPointMake(x + 70*i, 20)]];
  }
  event.enemies = enemies;
  return event;
}

- (YKLevelEvent *)lineEnemyEventWithNumEnemies:(NSUInteger)numEnemies delay:(CGFloat)delay position:(CGPoint)position style:(NSInteger)style {
  YKLevelEvent *event = [[YKLevelEvent alloc] init];
  NSMutableArray *enemies = [NSMutableArray arrayWithCapacity:numEnemies];
  NSArray *baseTimes = @[
                         @(0.1),
                         @(1)
                         ];
  NSArray *baseEvents = @[
                          @"turnDown",
                          @"fireAtPlayer"
                          ];
  for (NSUInteger i = 0; i < numEnemies; ++i) {
    YKAirplaneNode *enemy = [[YKAirplaneNode alloc] initWithStyle:style];
    NSMutableArray *times = [baseTimes mutableCopy];
    for (NSInteger j = 0; j < times.count; ++j) {
      NSNumber *time = times[j];
      times[j] = @([time floatValue] + delay * i);
    }
    enemy.events = baseEvents;
    enemy.times = times;
    [enemies addObject:[YKLevelEnemyBirth enemyBirthWithNode:enemy birthPlace:position]];
  }
  event.enemies = enemies;
  return event;
}

- (YKLevelEvent *)basicPowerUpEventWithType:(YKPowerUpType)type x:(CGFloat)x value:(CGFloat)value andTimeToExist:(NSTimeInterval)time {
  YKLevelEvent *event = [[YKLevelEvent alloc] init];
  YKPowerUp *powerUp = [[YKPowerUp alloc] initWithType:type value:value andTimeToExist:time];
  event.powerUp = [YKLevelPowerUpBirth powerUpBirthWithNode:powerUp birthPlace:CGPointMake(x, 20)];
  return event;
}

- (NSDictionary *)_gameEvents {
  return @{
           @(3) : [self lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(500, 20) style:4],
           @(6) : [self basicEnemyEventWithNumEnemies:6 x:80 style:3],
           @(8) : [self basicPowerUpEventWithType:YKHealth x:40 value:20.0 andTimeToExist:10.0],
           @(12) : [self basicPowerUpEventWithType:YKSpeed x:50 value:200.0 andTimeToExist:15.0]
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
  
  NSInteger realTime = (NSInteger)(currentTime - _startTime) % 20;
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
