//
//  YKPowerUp.m
//  HammyRocket
//
//  Created by Jim Liu on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKPowerUp.h"

NSString *const YKPowerUpName = @"YKPowerUp";

@interface YKPowerUp ()
@property (nonatomic, strong) SKSpriteNode *node;
@end

@implementation YKPowerUp

- (instancetype)initWithType:(YKPowerUpType)type value:(CGFloat)value andTimeToExist:(NSTimeInterval)time {
  if ((self = [super init])) {
    _type = type;
    _value = value;
    _timeToExist = time;
    self.name = YKPowerUpName;
    [self _createPowerUp:type];
  }
  return self;
}

- (void)update:(NSTimeInterval)diff {
  _timeToExist -= diff;
}

- (void)_createPowerUp:(YKPowerUpType)type {
  switch (type) {
    case YKHealth:
      self.node = [SKSpriteNode spriteNodeWithImageNamed:@"contribute_review_5star.png"];
      self.node.position = CGPointMake(0, 0);
      self.node.size = CGSizeMake(40, 40);
      [self addChild:self.node];
      break;
    case YKSpeed:
      self.node = [SKSpriteNode spriteNodeWithImageNamed:@"check_burst.png"];
      self.node.position = CGPointMake(0, 0);
      self.node.size = CGSizeMake(50, 50);
      [self addChild:self.node];
      break;
    case YKAmmo:
    default:
      break;
  }
}

- (CGFloat)hitRadius {
  return self.node.size.width/2;
}

@end
