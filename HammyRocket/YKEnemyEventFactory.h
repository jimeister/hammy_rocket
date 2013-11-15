//
//  YKEnemyEventFactory.h
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YKLevelEvent;

@interface YKEnemyEventFactory : NSObject

// Enemies fly down shoot, and then leave
+ (YKLevelEvent *)basicEnemyEventWithNumEnemies:(NSUInteger)numEnemies x:(CGFloat)x style:(NSInteger)style;

// Travel in a straight line, you pass in how they shoot
+ (YKLevelEvent *)lineEnemyEventWithNumEnemies:(NSUInteger)numEnemies delay:(CGFloat)delay position:(CGPoint)position style:(NSInteger)style
                               directionAction:(NSString *)directionAction firingTimes:(NSArray *)firingTimes firingActions:(NSArray *)firingActions
                                     baseSpeed:(CGFloat)baseSpeed;

+ (YKLevelEvent *)halfCircleCounterClockwiseEventWithNumEnemies:(NSUInteger)numEnemies delay:(CGFloat)delay position:(CGPoint)position style:(NSInteger)style
                                                    firingTimes:(NSArray *)firingTimes firingActions:(NSArray *)firingActions
                                                      baseSpeed:(CGFloat)baseSpeed;

+ (YKLevelEvent *)shallowLeftVEventWithNumEnemies:(NSUInteger)numEnemies delay:(CGFloat)delay position:(CGPoint)position style:(NSInteger)style
                                        baseSpeed:(CGFloat)baseSpeed;

+ (YKLevelEvent *)bigEnemyPlaneEventAtX:(CGFloat)x;

@end
