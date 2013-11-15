//
//  YKPowerUp.h
//  HammyRocket
//
//  Created by Jim Liu on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
  YKHealth,
  YKAmmo,
  YKSpeed
} YKPowerUpType;

extern NSString *const YKPowerUpName;

@interface YKPowerUp : SKNode

@property (nonatomic) YKPowerUpType type;
@property (nonatomic) CGFloat value;
@property (readonly, nonatomic) NSTimeInterval timeToExist;
@property (nonatomic, readonly) CGFloat hitRadius;

- (instancetype)initWithType:(YKPowerUpType)type value:(CGFloat)value andTimeToExist:(NSTimeInterval)time;
- (void)update:(NSTimeInterval)diff;

@end
