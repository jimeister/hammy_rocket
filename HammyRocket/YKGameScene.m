//
//  YKGameScene.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKGameScene.h"

@implementation YKGameScene {
  BOOL _contentCreated;
}

- (void)_createSceneContent {
  self.backgroundColor = [SKColor colorWithRed:0.0 green:0.0 blue:0.3 alpha:1.0];
  SKSpriteNode *rocket = [SKSpriteNode spriteNodeWithImageNamed:@"rocket.png"];
  rocket.position = CGPointMake(CGRectGetMidX(self.frame), 100);
  
  SKSpriteNode *rocket_interior = [SKSpriteNode spriteNodeWithImageNamed:@"rocket_interior.png"];
  rocket_interior.position = CGPointMake(0, 0);
  [rocket addChild:rocket_interior];
  
  SKSpriteNode *hammy = [SKSpriteNode spriteNodeWithImageNamed:@"hammy.png"];
  hammy.position = CGPointMake(0, -10.0);
  [rocket addChild:hammy];
  
  [self addChild:rocket];
}

- (void)didMoveToView:(SKView *)view {
  if (!_contentCreated) {
    [self _createSceneContent];
  }
}

#pragma mark UIResponder

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *firstTouch = [[touches allObjects] objectAtIndex:0];
  NSLog(@"%@", firstTouch);
}

@end
