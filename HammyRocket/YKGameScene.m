//
//  YKGameScene.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKGameScene.h"
#import "YKAirplaneNode.h"

@implementation YKGameScene {
  BOOL _contentCreated;
}

- (void)_createSceneContent {
  self.backgroundColor = [SKColor colorWithRed:0.0 green:0.0 blue:0.3 alpha:1.0];
  
  _rocket = [[YKHammyRocket alloc] init];
  [self.rocket createHammyRocketAtPosition:CGPointMake(CGRectGetMidX(self.frame), 100)];
  
  [self addChild:self.rocket.rocket];
}

- (void)didMoveToView:(SKView *)view {
  if (!_contentCreated) {
    [self _createSceneContent];
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint currentTouchPoint = [touch locationInNode:self];
  
  SKAction *move = [SKAction moveTo:currentTouchPoint duration:0.1];
  [self.rocket.rocket runAction:move];
}

@end
