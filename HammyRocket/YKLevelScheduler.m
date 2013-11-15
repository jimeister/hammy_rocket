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

static const NSInteger kCycleLength = 142;

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
  
//  return @{
//           // Step up yo game
//           @(74-73) : [YKEnemyEventFactory bigEnemyPlaneEventAtX:150],
//           @(75-73) : [YKEnemyEventFactory bigEnemyPlaneEventAtX:618],
//           @(76-73) : [YKEnemyEventFactory submarineEventAtPoint:CGPointMake(CGRectGetMidX([[UIScreen mainScreen] bounds]), -400) submergeTime:13],
//           @(80-73) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:4 delay:0.8 position:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) + 20, -50) style:0 directionAction:@"turnLeft" firingTimes:@[@(1), @(3), @(5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180],
//           @(81-73) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:4 delay:0.8 position:CGPointMake(-20, -100) style:0 directionAction:@"turnRight" firingTimes:@[@(1), @(3), @(5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180],
//           
//           @(84-73) : [YKEnemyEventFactory halfCircleCounterClockwiseEventWithNumEnemies:6 delay:0.8 position:CGPointMake(200, -50) style:2 firingTimes:@[@(2), @(3), @(4)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180],
//           @(86-73) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(75, 50) style:3 directionAction:@"turnDown" firingTimes:@[@(1), @(3), @(5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180 ammoSpeed:150],
//           @(87-73) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(693, 50) style:3 directionAction:@"turnDown" firingTimes:@[@(1), @(3), @(5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180 ammoSpeed:150],
//           @(88-73) : [self basicPowerUpEventWithType:YKHealth x:40 value:20.0 andTimeToExist:10.0],
//
//
//           };

  return @{
           @(1) : [YKEnemyEventFactory basicEnemyEventWithNumEnemies:3 x:100 style:0 timeToFlyDown:0],
           @(2) : [YKEnemyEventFactory basicEnemyEventWithNumEnemies:3 x:500 style:0 timeToFlyDown:0],
           @(4) : [YKEnemyEventFactory basicEnemyEventWithNumEnemies:5 x:230 style:1 timeToFlyDown:2],
           @(7) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(-20, -150) style:3 directionAction:@"turnShallowRightDown" firingTimes:@[@(1), @(3)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180],
           @(8) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(-20, -50) style:4 directionAction:@"turnShallowRightDown" firingTimes:@[@(0.5), @(2.5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180],
           @(12) : [YKEnemyEventFactory bigEnemyPlaneEventAtX:CGRectGetMidX([[UIScreen mainScreen] bounds])],
           
           // Speed powerup
           @(13) : [self basicPowerUpEventWithType:YKSpeed x:50 value:66 andTimeToExist:15.0],

           @(20) : [YKEnemyEventFactory shallowLeftVEventWithNumEnemies:5 delay:0.8 position:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) + 20, -70) style:0 baseSpeed:150 ammoSpeed:125],
           
           @(25) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) + 20, -100) style:3 directionAction:@"turnShallowLeftDown" firingTimes:@[@(1), @(3), @(5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180],
           @(26) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) + 20, -200) style:3 directionAction:@"turnShallowLeftDown" firingTimes:@[@(1), @(3), @(5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180],

           @(30) : [YKEnemyEventFactory basicEnemyEventWithNumEnemies:5 x:230 style:1 timeToFlyDown:1],
           @(32) : [YKEnemyEventFactory basicEnemyEventWithNumEnemies:3 x:100 style:0 timeToFlyDown:0],
           @(33) : [YKEnemyEventFactory basicEnemyEventWithNumEnemies:3 x:500 style:0 timeToFlyDown:0],
           
           @(35) : [YKEnemyEventFactory bigEnemyPlaneEventAtX:150],
           @(36) : [YKEnemyEventFactory bigEnemyPlaneEventAtX:618],
           
           // Speed powerup
           @(38) : [self basicPowerUpEventWithType:YKSpeed x:50 value:66 andTimeToExist:15.0],
           
           // Bring on the first sub
           @(46) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(150, 50) style:3 directionAction:@"turnDown" firingTimes:@[@(1), @(3)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180 ammoSpeed:110],
           @(48) : [YKEnemyEventFactory submarineEventAtPoint:CGPointMake(CGRectGetMidX([[UIScreen mainScreen] bounds]), -400)],
           @(50) : [YKEnemyEventFactory shallowLeftVEventWithNumEnemies:3 delay:0.8 position:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) + 20, -70) style:4 baseSpeed:150],
           
           // Ammo powerup
           @(54) : [self basicPowerUpEventWithType:YKAmmo x:100 value:200.0 andTimeToExist:15.0],
           
           @(58) : [YKEnemyEventFactory halfCircleCounterClockwiseEventWithNumEnemies:7 delay:0.8 position:CGPointMake(-20, -50) style:2 firingTimes:@[@(2.5), @(3.5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180],
           @(60) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(-20, -150) style:3 directionAction:@"turnShallowRightDown" firingTimes:@[@(1), @(3)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180 ammoSpeed:150],
           @(62) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(-20, -250) style:0 directionAction:@"turnShallowRightDown" firingTimes:@[@(0.5), @(2.5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180 ammoSpeed:150],
           @(66) : [YKEnemyEventFactory bigEnemyPlaneEventAtX:CGRectGetMidX([[UIScreen mainScreen] bounds])],
           // Hard event
           @(69) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(150, 50) style:3 directionAction:@"turnDown" firingTimes:@[@(1), @(3), @(5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180 ammoSpeed:150],
           @(70) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(618, 50) style:3 directionAction:@"turnDown" firingTimes:@[@(1), @(3), @(5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180 ammoSpeed:150],
           
           // The health powerup drops
           @(71) : [self basicPowerUpEventWithType:YKHealth x:40 value:20.0 andTimeToExist:10.0],
           
           @(1+73) : [YKEnemyEventFactory basicEnemyEventWithNumEnemies:5 x:230 style:0 timeToFlyDown:0],
           @(4+73) : [YKEnemyEventFactory bigEnemyPlaneEventAtX:CGRectGetMidX([[UIScreen mainScreen] bounds])],
           @(5+73) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:3 delay:1.2 position:CGPointMake(-50, 0) style:1 directionAction:@"turnRightDown" firingTimes:@[@(1), @(3), @(5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer", @"fireAtPlayer"] baseSpeed:200 ammoSpeed:110],
           @(6+73) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:3 delay:1.2 position:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) + 50, 0) style:1 directionAction:@"turnLeftDown" firingTimes:@[@(1), @(3), @(5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer", @"fireAtPlayer"] baseSpeed:200 ammoSpeed:110],
           
           @(8+73) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:8 delay:0.6 position:CGPointMake(-50, -100) style:2 directionAction:@"turnRight" firingTimes:@[@(1), @(3), @(5)] firingActions:@[@"fireDown", @"fireDown", @"fireDown"] baseSpeed:200 ammoSpeed:110],
           @(11+73) : [YKEnemyEventFactory lineEnemySyncedShootingEventWithNumEnemies:8 delay:0.6 position:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) + 50, -200) style:3 directionAction:@"turnLeft" firingTimes:@[@(1), @(3), @(5)] firingActions:@[@"fireDown", @"fireDown", @"fireDown"] baseSpeed:200 ammoSpeed:110],
           
           // Speed powerup
           @(15+73) : [self basicPowerUpEventWithType:YKSpeed x:50 value:66 andTimeToExist:15.0],
           @(16+73) : [YKEnemyEventFactory bigEnemyPlaneEventAtX:150],
           @(17+73) : [YKEnemyEventFactory bigEnemyPlaneEventAtX:618],
           @(18+73) : [YKEnemyEventFactory lineEnemySyncedShootingEventWithNumEnemies:7 delay:0.9 position:CGPointMake(-50, -250) style:4 directionAction:@"turnRight" firingTimes:@[@(1), @(3), @(5), @(7)] firingActions:@[@"fireDown", @"fireDown", @"fireDown", @"fireDown"] baseSpeed:200 ammoSpeed:110],
           
           @(29+73) : [YKEnemyEventFactory submarineEventAtPoint:CGPointMake(CGRectGetMidX([[UIScreen mainScreen] bounds]), -300)],
           @(30+73) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(-20, -150) style:0 directionAction:@"turnShallowRightDown" firingTimes:@[@(1), @(3)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180 ammoSpeed:150],
           @(31+73) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(-20, -50) style:4 directionAction:@"turnShallowRightDown" firingTimes:@[@(0.5), @(2.5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180 ammoSpeed:150],
           
           // Step up yo game
           @(4+108) : [YKEnemyEventFactory bigEnemyPlaneEventAtX:150],
           @(5+108) : [YKEnemyEventFactory bigEnemyPlaneEventAtX:618],
           @(6+108) : [YKEnemyEventFactory submarineEventAtPoint:CGPointMake(CGRectGetMidX([[UIScreen mainScreen] bounds]), -400) submergeTime:13],
           @(10+108) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:4 delay:0.8 position:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) + 20, -50) style:0 directionAction:@"turnLeft" firingTimes:@[@(1), @(3), @(5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180],
           @(11+108) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:4 delay:0.8 position:CGPointMake(-20, -100) style:0 directionAction:@"turnRight" firingTimes:@[@(1), @(3), @(5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180],
           
           @(14+108) : [YKEnemyEventFactory halfCircleCounterClockwiseEventWithNumEnemies:6 delay:0.8 position:CGPointMake(200, -50) style:2 firingTimes:@[@(2), @(3), @(4)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180],
           @(16+108) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(75, 50) style:3 directionAction:@"turnDown" firingTimes:@[@(1), @(3), @(5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180 ammoSpeed:150],
           @(17+108) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(693, 50) style:3 directionAction:@"turnDown" firingTimes:@[@(1), @(3), @(5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180 ammoSpeed:150],
           @(18+108) : [self basicPowerUpEventWithType:YKHealth x:40 value:20.0 andTimeToExist:10.0],

           // Two subs
           @(130) : [YKEnemyEventFactory submarineEventAtPoint:CGPointMake(CGRectGetMidX([[UIScreen mainScreen] bounds]) - 90, -400)],
           @(131) : [YKEnemyEventFactory submarineEventAtPoint:CGPointMake(CGRectGetMidX([[UIScreen mainScreen] bounds]) + 90, -400)],
           @(133) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(75, 50) style:3 directionAction:@"turnDown" firingTimes:@[@(1), @(3), @(5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180 ammoSpeed:160],
           @(134) : [YKEnemyEventFactory lineEnemyEventWithNumEnemies:5 delay:0.8 position:CGPointMake(693, 50) style:3 directionAction:@"turnDown" firingTimes:@[@(1), @(3), @(5)] firingActions:@[@"fireAtPlayer", @"fireAtPlayer", @"fireAtPlayer"] baseSpeed:180 ammoSpeed:160],
      
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
