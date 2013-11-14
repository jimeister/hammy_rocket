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
  
  SKAction *fire = [SKAction sequence: @[
                                          [SKAction performSelector:@selector(createAmmo) onTarget:self],
                                          [SKAction waitForDuration:0.10 withRange:0.15]
                                          ]];
  [self.rocket runAction:[SKAction repeatActionForever:fire]];
}

- (void)didMoveToView:(SKView *)view {
  if (!_contentCreated) {
    [self _createSceneContent];
  }
}

- (void)update:(NSTimeInterval)currentTime {
  NSTimeInterval diff = currentTime - _lastUpdateTime;
  
  [self enumerateChildNodesWithName:@"ammo" usingBlock:^(SKNode *node, BOOL *stop) {
    // Update ammo position here
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
  CGPoint currentTouchPoint = [touch locationInNode:self];
  SKAction *move = [SKAction moveTo:currentTouchPoint duration:0.1];
  [self.rocket runAction:move];
  _lastTouch = [touch locationInNode:self];
}

<<<<<<< HEAD
- (void)createAmmo {
  SKSpriteNode *ammo = [[SKSpriteNode alloc] initWithColor:[SKColor whiteColor] size:CGSizeMake(2,5)];
  ammo.position = CGPointMake(self.rocket.position.x, self.rocket.position.y + 40);
  ammo.name = @"ammo";
  [self addChild:ammo];
=======
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  _touched = NO;
>>>>>>> Refactor hammy move, add update loop
}

@end
