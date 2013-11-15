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

static const NSInteger kCycleLength = 100;

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

- (NSDictionary *)_hardEventWithOffset:(NSInteger)offset {
  return @{
           @(0+offset) : [YKEnemyEventFactory bigEnemyPlaneEventAtX:CGRectGetMidX([[UIScreen mainScreen] bounds])],
           @(3+offset) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(150, 50) style:3 directionAction:@"turnDown" firingTimes:@[@(1), @(3), @(5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180 ammoSpeed:150],
           @(4+offset) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(618, 50) style:3 directionAction:@"turnDown" firingTimes:@[@(1), @(3), @(5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180 ammoSpeed:150],
           };
}

- (NSDictionary *)_gameEvents {
  /*
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
   */
  
  return @{
           @(1) : [YKEnemyEventFactory basicEnemyEventWithNumEnemies:3 x:100 style:0 timeToFlyDown:0],
           @(2) : [YKEnemyEventFactory basicEnemyEventWithNumEnemies:3 x:500 style:0 timeToFlyDown:0],
           @(4) : [YKEnemyEventFactory basicEnemyEventWithNumEnemies:5 x:230 style:1 timeToFlyDown:2],
           @(7) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(-20, -150) style:3 directionAction:@"turnShallowRightDown" firingTimes:@[@(1), @(3)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180],
           @(8) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(-20, -50) style:4 directionAction:@"turnShallowRightDown" firingTimes:@[@(0.5), @(2.5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180],
           @(12) : [YKEnemyEventFactory bigEnemyPlaneEventAtX:CGRectGetMidX([[UIScreen mainScreen] bounds])],
           
           // Speed powerup
           @(13) : [self basicPowerUpEventWithType:YKSpeed x:50 value:100 andTimeToExist:15.0],

           @(20) : [YKEnemyEventFactory shallowLeftVEventWithNumEnemies:5 delay:0.8 position:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) + 20, -70) style:0 baseSpeed:150 ammoSpeed:125],
           
           @(25) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) + 20, -100) style:3 directionAction:@"turnShallowLeftDown" firingTimes:@[@(1), @(3), @(5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180],
           @(26) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) + 20, -200) style:3 directionAction:@"turnShallowLeftDown" firingTimes:@[@(1), @(3), @(5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180],

           @(30) : [YKEnemyEventFactory basicEnemyEventWithNumEnemies:5 x:230 style:1 timeToFlyDown:1],
           @(32) : [YKEnemyEventFactory basicEnemyEventWithNumEnemies:3 x:100 style:0 timeToFlyDown:0],
           @(33) : [YKEnemyEventFactory basicEnemyEventWithNumEnemies:3 x:500 style:0 timeToFlyDown:0],
           
           @(35) : [YKEnemyEventFactory bigEnemyPlaneEventAtX:150],
           @(36) : [YKEnemyEventFactory bigEnemyPlaneEventAtX:618],
           
           // The health powerup drops
           @(37) : [self basicPowerUpEventWithType:YKHealth x:40 value:20.0 andTimeToExist:10.0],
           // Speed powerup
           @(38) : [self basicPowerUpEventWithType:YKSpeed x:50 value:100 andTimeToExist:15.0],
           
           // Bring on the first sub
           @(46) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(150, 50) style:3 directionAction:@"turnDown" firingTimes:@[@(1), @(3)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180 ammoSpeed:110],
           @(48) : [YKEnemyEventFactory submarineEventAtPoint:CGPointMake(CGRectGetMidX([[UIScreen mainScreen] bounds]), -400)],
           @(50) : [YKEnemyEventFactory shallowLeftVEventWithNumEnemies:3 delay:0.8 position:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) + 20, -70) style:4 baseSpeed:150],
           
           // Ammo powerup
           @(54) : [self basicPowerUpEventWithType:YKAmmo x:100 value:200.0 andTimeToExist:15.0],
           
           @(58) : [YKEnemyEventFactory halfCircleCounterClockwiseEventWithNumEnemies:7 delay:0.8 position:CGPointMake(-20, -50) style:2 firingTimes:@[@(2.5), @(3.5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180],
           @(60) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(-20, -150) style:3 directionAction:@"turnShallowRightDown" firingTimes:@[@(1), @(3)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180 ammoSpeed:150],
           @(62) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(-20, -250) style:0 directionAction:@"turnShallowRightDown" firingTimes:@[@(0.5), @(2.5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180 ammoSpeed:150],
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
  
  NSInteger realTime = (NSInteger)(currentTime - _startTime) % kCycleLength;
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
