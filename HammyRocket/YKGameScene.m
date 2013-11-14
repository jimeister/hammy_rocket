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
  NSTimeInterval _lastUpdateTime;
  CGPoint _lastTouch;
}

- (void)_createSceneContent {
  self.backgroundColor = [SKColor colorWithRed:0.0 green:0.0 blue:0.3 alpha:1.0];
  
  _rocket = [[YKHammyRocket alloc] init];
  _rocket.position = CGPointMake(CGRectGetMidX(self.frame), 100);
  [self addChild:self.rocket];
}

- (void)didMoveToView:(SKView *)view {
  if (!_contentCreated) {
    [self _createSceneContent];
  }
}

- (void)update:(NSTimeInterval)currentTime {
  NSTimeInterval diff = currentTime - _lastUpdateTime;
  
  
  
  _lastUpdateTime = currentTime;
}

#pragma mark UIResponder

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  _lastTouch = [touch locationInNode:self];
}

@end
