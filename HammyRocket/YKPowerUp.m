//
//  YKPowerUp.m
//  HammyRocket
//
//  Created by Jim Liu on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKPowerUp.h"

NSString *const YKPowerUpName = @"YKPowerUp";

@implementation YKPowerUp

- (instancetype)initWithType:(YKPowerUpType)type value:(CGFloat)value andTimeToExist:(NSTimeInterval)time {
  if ((self = [super init])) {
    _type = type;
    _value = value;
    _timeToExist = time;
    self.name = YKPowerUpName;
  }
  return self;
}

- (void)update:(NSTimeInterval)diff {
  _timeToExist -= diff;
}

@end
