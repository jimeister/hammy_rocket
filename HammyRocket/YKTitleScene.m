//
//  YKTitleScene.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKTitleScene.h"
#import "YKGameScene.h"

static NSString *const kDefaultFont = @"Courier";

static NSString *const kStartNode = @"kStartNode";


@implementation YKTitleScene {
  BOOL _contentCreated;
}

- (void)_createSceneContent {
  self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
  
  SKLabelNode *startLabel = [SKLabelNode labelNodeWithFontNamed:kDefaultFont];
  startLabel.text = @"Start";
  startLabel.name = kStartNode;
  startLabel.fontSize = 60.0;
  startLabel.fontColor = [UIColor whiteColor];
  startLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
  [self addChild:startLabel];
}

- (void)didMoveToView:(SKView *)view {
  if (!_contentCreated) {
    [self _createSceneContent];
  }
}

- (void)_startGame {
  SKScene *gameScene = [[YKGameScene alloc] initWithSize:self.size];
  [self.view presentScene:gameScene transition:[SKTransition fadeWithDuration:0.5]];
}

#pragma mark UIResponder

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  
  if (touches.count == 1) {
    UITouch *touch = touches.anyObject;
    
    SKNode *node = [self nodeAtPoint:[touch locationInNode:self]];
    if (node.name == kStartNode) {
      [self _startGame];
    }
  }
}

@end
