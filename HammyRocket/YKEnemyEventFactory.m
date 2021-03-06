//
//  YKEnemyEventFactory.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKEnemyEventFactory.h"
#import "YKLevelEvent.h"
#import "YKAirplaneNode.h"
#import "YKSubmarineNode.h"
#import "YKBigPlaneNode.h"

@implementation YKEnemyEventFactory

// Enemies fly down shoot, and then leave
+ (YKLevelEvent *)basicEnemyEventWithNumEnemies:(NSUInteger)numEnemies x:(CGFloat)x style:(NSInteger)style timeToFlyDown:(CGFloat)time {
  YKLevelEvent *event = [[YKLevelEvent alloc] init];
  NSMutableArray *enemies = [NSMutableArray arrayWithCapacity:numEnemies];
  for (NSUInteger i = 0; i < numEnemies; ++i) {
    YKAirplaneNode *enemy = [[YKAirplaneNode alloc] initWithStyle:style];
    NSMutableArray *times = [NSMutableArray arrayWithCapacity:enemy.times.count];
    for (NSNumber *num in enemy.times) {
      [times addObject:@([num floatValue] + time)];
    }
    enemy.times = times;
    [enemy turnDown];
    [enemies addObject:[YKLevelEnemyBirth enemyBirthWithNode:enemy birthPlace:CGPointMake(x + 70*i, 20)]];
  }
  event.enemies = enemies;
  return event;
}

// Travel in a straight line, you pass in how they shoot
+ (YKLevelEvent *)lineEnemyEventWithNumEnemies:(NSUInteger)numEnemies delay:(CGFloat)delay position:(CGPoint)position style:(NSInteger)style
                               directionAction:(NSString *)directionAction firingTimes:(NSArray *)firingTimes firingActions:(NSArray *)firingActions
                                     baseSpeed:(CGFloat)baseSpeed ammoSpeed:(CGFloat)ammoSpeed {
  YKLevelEvent *event = [[YKLevelEvent alloc] init];
  NSMutableArray *enemies = [NSMutableArray arrayWithCapacity:numEnemies];
  NSArray *baseTimes = @[@(0.1)];
  NSArray *baseEvents = @[directionAction];
  if (firingTimes && firingActions) {
    baseTimes = [baseTimes arrayByAddingObjectsFromArray:firingTimes];
    baseEvents = [baseEvents arrayByAddingObjectsFromArray:firingActions];
  }
  for (NSUInteger i = 0; i < numEnemies; ++i) {
    YKAirplaneNode *enemy = [[YKAirplaneNode alloc] initWithStyle:style];
    NSMutableArray *times = [baseTimes mutableCopy];
    for (NSInteger j = 0; j < times.count; ++j) {
      NSNumber *time = times[j];
      times[j] = @([time floatValue] + delay * i);
    }
    enemy.events = baseEvents;
    enemy.times = times;
    enemy.baseSpeed = baseSpeed;
    enemy.ammoSpeed = ammoSpeed;
    enemy.score = 150;
    [enemies addObject:[YKLevelEnemyBirth enemyBirthWithNode:enemy birthPlace:position]];
  }
  event.enemies = enemies;
  return event;
}

// Travel in a straight line, all shoot at same time though, not staggered
+ (YKLevelEvent *)lineEnemySyncedShootingEventWithNumEnemies:(NSUInteger)numEnemies delay:(CGFloat)delay position:(CGPoint)position style:(NSInteger)style
                                             directionAction:(NSString *)directionAction firingTimes:(NSArray *)firingTimes firingActions:(NSArray *)firingActions
                                                   baseSpeed:(CGFloat)baseSpeed ammoSpeed:(CGFloat)ammoSpeed {
  YKLevelEvent *event = [[YKLevelEvent alloc] init];
  NSMutableArray *enemies = [NSMutableArray arrayWithCapacity:numEnemies];
  NSArray *baseTimes = @[@(0.1)];
  NSArray *baseEvents = @[directionAction];
  if (firingTimes && firingActions) {
    baseTimes = [baseTimes arrayByAddingObjectsFromArray:firingTimes];
    baseEvents = [baseEvents arrayByAddingObjectsFromArray:firingActions];
  }
  for (NSUInteger i = 0; i < numEnemies; ++i) {
    YKAirplaneNode *enemy = [[YKAirplaneNode alloc] initWithStyle:style];
    NSMutableArray *times = [baseTimes mutableCopy];
    for (NSInteger j = 0; j < times.count; ++j) {
      NSNumber *time = times[j];
      if (![firingTimes containsObject:time]) {
        times[j] = @([time floatValue] + delay * i);
      }
    }
    enemy.events = baseEvents;
    enemy.times = times;
    enemy.baseSpeed = baseSpeed;
    enemy.ammoSpeed = ammoSpeed;
    enemy.score = 150;
    [enemies addObject:[YKLevelEnemyBirth enemyBirthWithNode:enemy birthPlace:position]];
  }
  event.enemies = enemies;
  return event;
}

+ (YKLevelEvent *)lineEnemyEventWithNumEnemies:(NSUInteger)numEnemies delay:(CGFloat)delay position:(CGPoint)position style:(NSInteger)style
                               directionAction:(NSString *)directionAction firingTimes:(NSArray *)firingTimes firingActions:(NSArray *)firingActions
                                     baseSpeed:(CGFloat)baseSpeed {
  return [[self class] lineEnemyEventWithNumEnemies:numEnemies delay:delay position:position style:style directionAction:directionAction firingTimes:firingTimes firingActions:firingActions baseSpeed:baseSpeed ammoSpeed:100];
}

+ (YKLevelEvent *)halfCircleCounterClockwiseEventWithNumEnemies:(NSUInteger)numEnemies delay:(CGFloat)delay position:(CGPoint)position style:(NSInteger)style
                                                    firingTimes:(NSArray *)firingTimes firingActions:(NSArray *)firingActions
                                                      baseSpeed:(CGFloat)baseSpeed {
  YKLevelEvent *event = [[YKLevelEvent alloc] init];
  NSMutableArray *enemies = [NSMutableArray arrayWithCapacity:numEnemies];
  NSMutableArray *baseTimes = [@[@(0.1), @(1), @(5)] mutableCopy];
  NSMutableArray *baseEvents = [@[@"turnRightDown", @"turnRight", @"turnRightUp"] mutableCopy];
  if (firingTimes && firingActions) {
    for (NSInteger j = firingTimes.count - 1; j >= 0; --j) {
      for (NSInteger i = baseTimes.count - 1; i >= 0; --i) {
        if ([firingTimes[j] floatValue] < [baseTimes[i] floatValue]) {
          [baseTimes insertObject:firingTimes[j] atIndex:i];
          [baseEvents insertObject:firingActions[j] atIndex:i];
        }
      }
    }
  }
  for (NSUInteger i = 0; i < numEnemies; ++i) {
    YKAirplaneNode *enemy = [[YKAirplaneNode alloc] initWithStyle:style];
    NSMutableArray *times = [baseTimes mutableCopy];
    for (NSInteger j = 0; j < times.count; ++j) {
      NSNumber *time = times[j];
      times[j] = @([time floatValue] + delay * i);
    }
    enemy.events = baseEvents;
    enemy.times = times;
    enemy.baseSpeed = baseSpeed;
    [enemies addObject:[YKLevelEnemyBirth enemyBirthWithNode:enemy birthPlace:position]];
  }
  event.enemies = enemies;
  return event;
}

+ (YKLevelEvent *)shallowLeftVEventWithNumEnemies:(NSUInteger)numEnemies delay:(CGFloat)delay position:(CGPoint)position style:(NSInteger)style
                                        baseSpeed:(CGFloat)baseSpeed ammoSpeed:(CGFloat)ammoSpeed {
  YKLevelEvent *event = [[YKLevelEvent alloc] init];
  NSMutableArray *enemies = [NSMutableArray arrayWithCapacity:numEnemies];
  NSMutableArray *baseTimes = [@[@(0.1), @(3), @(3.1)] mutableCopy];
  NSMutableArray *baseEvents = [@[@"turnShallowLeftDown", @"fireAtPlayer", @"turnShallowLeftUp"] mutableCopy];

  for (NSUInteger i = 0; i < numEnemies; ++i) {
    YKAirplaneNode *enemy = [[YKAirplaneNode alloc] initWithStyle:style];
    NSMutableArray *times = [baseTimes mutableCopy];
    for (NSInteger j = 0; j < times.count; ++j) {
      NSNumber *time = times[j];
      times[j] = @([time floatValue] + delay * i);
    }
    enemy.events = baseEvents;
    enemy.times = times;
    enemy.baseSpeed = baseSpeed;
    enemy.ammoSpeed = ammoSpeed;
    [enemies addObject:[YKLevelEnemyBirth enemyBirthWithNode:enemy birthPlace:position]];
  }
  event.enemies = enemies;
  return event;
}

+ (YKLevelEvent *)shallowLeftVEventWithNumEnemies:(NSUInteger)numEnemies delay:(CGFloat)delay position:(CGPoint)position style:(NSInteger)style
                                        baseSpeed:(CGFloat)baseSpeed {
  return [[self class] shallowLeftVEventWithNumEnemies:numEnemies delay:delay position:position style:style baseSpeed:baseSpeed ammoSpeed:100];
}

+ (YKLevelEvent *)bigEnemyPlaneEventAtX:(CGFloat)x {
  YKLevelEvent *event = [[YKLevelEvent alloc] init];
  YKBigPlaneNode *bigPlane = [[YKBigPlaneNode alloc] init];
  event.enemies = @[[YKLevelEnemyBirth enemyBirthWithNode:bigPlane birthPlace:CGPointMake(x, 20)]];
  return event;
}

+ (YKLevelEvent *)submarineEventAtPoint:(CGPoint)point {
  return [[self class] submarineEventAtPoint:point submergeTime:8];
}

+ (YKLevelEvent *)submarineEventAtPoint:(CGPoint)point submergeTime:(CGFloat)submergeTime {
  YKLevelEvent *event = [[YKLevelEvent alloc] init];
  YKSubmarineNode *sub = [[YKSubmarineNode alloc] initWithSubmergeTime:submergeTime];
  event.enemies = @[[YKLevelEnemyBirth enemyBirthWithNode:sub birthPlace:point]];
  return event;
}

@end
