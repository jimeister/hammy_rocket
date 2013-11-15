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
#import "YKEnemyEventFactory.h"

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

- (YKLevelEvent *)basicPowerUpEventWithType:(YKPowerUpType)type x:(CGFloat)x value:(CGFloat)value andTimeToExist:(NSTimeInterval)time {
  YKLevelEvent *event = [[YKLevelEvent alloc] init];
  YKPowerUp *powerUp = [[YKPowerUp alloc] initWithType:type value:value andTimeToExist:time];
  event.powerUp = [YKLevelPowerUpBirth powerUpBirthWithNode:powerUp birthPlace:CGPointMake(x, 20)];
  return event;
}

- (NSDictionary *)_gameEvents {
  return @{
           @(1) : [YKEnemyEventFactory submarineEventAtPoint:CGPointMake(CGRectGetMidX([[UIScreen mainScreen] bounds]), -400)],
           @(2) : [YKEnemyEventFactory halfCircleCounterClockwiseEventWithNumEnemies:4 delay:0.8 position:CGPointMake(-20, -50) style:2 firingTimes:@[@(3)] firingActions:@[@"fireAtPlayer"] baseSpeed:180],
           @(3) : [YKEnemyEventFactory shallowLeftVEventWithNumEnemies:5 delay:0.8 position:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) + 20, -70) style:0 baseSpeed:150],
           @(4) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(-20, -100) style:4 directionAction:@"turnShallowRightDown" firingTimes:@[@(1), @(3)] firingActions:@[@"fireDown", @"fireDown"] baseSpeed:180],
           @(5) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) + 20, -100) style:4 directionAction:@"turnShallowLeftDown" firingTimes:@[@(1), @(3)] firingActions:@[@"fireDown", @"fireDown"] baseSpeed:180],
           @(6) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(500, 20) style:4 directionAction:@"turnDown" firingTimes:@[@(1), @(2)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer"] baseSpeed:130],
           @(8) : [YKEnemyEventFactory basicEnemyEventWithNumEnemies:6 x:80 style:3],
           @(10) : [self basicPowerUpEventWithType:YKHealth x:40 value:20.0 andTimeToExist:10.0],
           @(12) : [self basicPowerUpEventWithType:YKSpeed x:50 value:200.0 andTimeToExist:15.0],
           @(14) : [self basicPowerUpEventWithType:YKAmmo x:100 value:200.0 andTimeToExist:15.0],
           @(15) : [YKEnemyEventFactory bigEnemyPlaneEventAtX:CGRectGetMidX([[UIScreen mainScreen] bounds])],
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
