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
#import "YKLevelScheduler.h"
#import "YKEnemyNode.h"

@interface YKGameScene ()
@property (strong, nonatomic) YKLevelScheduler *scheduler;
@end

@implementation YKGameScene {
  BOOL _contentCreated;
  NSTimeInterval _lastUpdateTime;
  BOOL _touched;
  BOOL _canFire;
  CGPoint _lastTouch;
}

@synthesize scheduler=_scheduler;

- (YKLevelScheduler *)scheduler {
  if (!_scheduler) {
    _scheduler = [[YKLevelScheduler alloc] init];
  }
  return _scheduler;
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
}

- (void)didMoveToView:(SKView *)view {
  if (!_contentCreated) {
    [self _createSceneContent];
  }
}
  
- (void)_handlePlayerMoveWithDiff:(NSTimeInterval)diff {
  if (_touched) {
    CGFloat rocketVelocity = _rocket.maxVelocity * diff;
    CGPoint rocketPosition = _rocket.position;
    CGVector direction = CGVectorMake(_lastTouch.x - rocketPosition.x, _lastTouch.y - rocketPosition.y);
    CGFloat scale = MIN(rocketVelocity / CPCGVectorMagnitude(direction), 1.0);
    CGVector velocity = CGVectorMake(direction.dx * scale, direction.dy * scale);
    _rocket.position = CGPointMake(rocketPosition.x + velocity.dx, rocketPosition.y + velocity.dy);
  }
}

- (void)update:(NSTimeInterval)currentTime {
  NSTimeInterval diff = currentTime - _lastUpdateTime;
  
  [self _handlePlayerMoveWithDiff:diff];
  if (_touched && _canFire) {
    _canFire = NO;
    [self.rocket runAction:self.ammo.fire completion:^() {
      _canFire = YES;
    }];
  }
  
  // Update ammo position here
  [self.ammo enumerateChildNodesWithName:@"ammo" usingBlock:^(SKNode *ammoNode, BOOL *stop) {
    if (CGPointEqualToPoint(ammoNode.position, CGPointMake(0, 0))) {
      ammoNode.position = CGPointMake(_rocket.position.x, _rocket.position.y + 40);
    }
    else {
      CGFloat ammoVelocity = self.ammo.ammoVelocity * diff;
      CGPoint position = ammoNode.position;
      ammoNode.position = CGPointMake(position.x, position.y + ammoVelocity);
    }
    
    if (ammoNode.position.y > self.frame.size.height) {
      [ammoNode removeFromParent];
    }
    
    [self enumerateChildNodesWithName:YKEnemyNodeName usingBlock:^(SKNode *node, BOOL *stop) {
      if (ammoNode.position.x > CGRectGetMinX(node.frame) && ammoNode.position.x < CGRectGetMaxX(node.frame) &&
          ammoNode.position.y > CGRectGetMinY(node.frame) && ammoNode.position.y < CGRectGetMaxY(node.frame)) {
        [ammoNode removeFromParent];
      }
    }];
  }];

  YKLevelEvent *event = [self.scheduler eventForCurrentTime:currentTime];
  for (YKLevelEnemyBirth *enemyBirth in event.enemies) {
    enemyBirth.enemyNode.position = CGPointMake(enemyBirth.birthPlace.x, enemyBirth.birthPlace.y + CGRectGetMaxY(self.frame));
    [self addChild:enemyBirth.enemyNode];
  }
  
  [self enumerateChildNodesWithName:YKEnemyNodeName usingBlock:^(SKNode *node, BOOL *stop) {
    YKEnemyNode *enemy = (YKEnemyNode *)node;
    enemy.position = CGPointMake(enemy.position.x + enemy.velocity.dx * diff, enemy.position.y + enemy.velocity.dy * diff);
    [enemy update:diff];
    
    if (enemy.position.y < -50 || enemy.position.y > CGRectGetMaxY(self.frame) + 50 ||
        enemy.position.x < -50 || enemy.position.x > CGRectGetMaxX(self.frame) + 50) {
      [enemy removeFromParent];
    }
  }];
  
  
  _lastUpdateTime = currentTime;
}

#pragma mark UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  if ([touches count] == 3) {
    self.view.paused = YES;
  }
  else {
    self.view.paused = NO;
    _touched = YES;
    _canFire = YES;
    UITouch *touch = [touches anyObject];
    _lastTouch = [touch locationInNode:self];
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  _lastTouch = [touch locationInNode:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  _touched = NO;
}

@end
