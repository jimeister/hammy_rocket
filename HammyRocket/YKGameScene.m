//
//  YKGameScene.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKGameScene.h"
#import "YKAirplaneNode.h"
#import "CPMath.h"

@implementation YKGameScene {
  BOOL _contentCreated;
  NSTimeInterval _lastUpdateTime;
  BOOL _touched;
  CGPoint _lastTouch;
}

- (void)_createSceneContent {
  self.backgroundColor = [SKColor colorWithRed:0.0 green:0.0 blue:0.3 alpha:1.0];
  _lastUpdateTime = 0.0;
  
  _rocket = [[YKHammyRocket alloc] init];
  _rocket.position = CGPointMake(CGRectGetMidX(self.frame), 100);
  [self addChild:self.rocket];
  
  _ammo = [[YKRocketAmmo alloc] initWithFireRate:0.20];
  [self.ammo createFireAction];
  [self addChild:self.ammo];
  
  [self.rocket runAction:[SKAction repeatActionForever:self.ammo.fire]];
}

- (void)didMoveToView:(SKView *)view {
  if (!_contentCreated) {
    [self _createSceneContent];
  }
}

- (void)update:(NSTimeInterval)currentTime {
  NSTimeInterval diff = currentTime - _lastUpdateTime;
  
  // Update ammo position here
  [self.ammo enumerateChildNodesWithName:@"ammo" usingBlock:^(SKNode *node, BOOL *stop) {
    if (CGPointEqualToPoint(node.position, CGPointMake(0, 0))) {
      node.position = CGPointMake(_rocket.position.x, _rocket.position.y + 40);
    }
    else {
      CGFloat ammoVelocity = self.ammo.ammoVelocity * diff;
      CGPoint position = node.position;
      node.position = CGPointMake(position.x, position.y + ammoVelocity);
    }
    
    if (node.position.y > self.frame.size.height) {
      [node removeFromParent];
    }
  }];
  
  if (_touched) {
    CGFloat rocketVelocity = _rocket.maxVelocity * diff;
    CGPoint rocketPosition = _rocket.position;
    CGVector direction = CGVectorMake(_lastTouch.x - rocketPosition.x, _lastTouch.y - rocketPosition.y);
    CGFloat scale = rocketVelocity / CPCGVectorMagnitude(direction);
    CGVector velocity = CGVectorMake(direction.dx * scale, direction.dy * scale);
    _rocket.position = CGPointMake(rocketPosition.x + velocity.dx, rocketPosition.y + velocity.dy);
  }
  
  _lastUpdateTime = currentTime;
}

#pragma mark UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  _touched = YES;
  UITouch *touch = [touches anyObject];
  _lastTouch = [touch locationInNode:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  _lastTouch = [touch locationInNode:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  _touched = NO;
}

@end
