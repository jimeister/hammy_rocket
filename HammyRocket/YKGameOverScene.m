//
//  YKGameOverScene.m
//  HammyRocket
//
//  Created by Jim Liu on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKGameOverScene.h"
#import "YKTitleScene.h"
#import "YKGameScene.h"

static NSString *const kDefaultFont = @"Courier";
static NSString *const kPlayAgainNode = @"kPlayAgainNode";
static NSString *const kQuitNode = @"kQuitNode";

@implementation YKGameOverScene {
  BOOL _contentCreated;
}

- (void)_createSceneContent {
  self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
  
  SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:kDefaultFont];
  gameOverLabel.text = @"GAME OVER";
  gameOverLabel.fontSize = 60.0;
  gameOverLabel.fontColor = [UIColor whiteColor];
  gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), 900);
  [self addChild:gameOverLabel];
  
  SKLabelNode *yourScoreLabel = [SKLabelNode labelNodeWithFontNamed:kDefaultFont];
  yourScoreLabel.text = @"Your score was";
  yourScoreLabel.fontSize = 30.0;
  yourScoreLabel.fontColor = [UIColor whiteColor];
  yourScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), 750);
  [self addChild:yourScoreLabel];
  
  SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:kDefaultFont];
  scoreLabel.text = [NSString stringWithFormat:@"%d", self.finalScore];
  scoreLabel.fontSize = 40.0;
  scoreLabel.fontColor = [UIColor whiteColor];
  scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), 700);
  [self addChild:scoreLabel];
  
  SKLabelNode *playAgainLabel = [SKLabelNode labelNodeWithFontNamed:kDefaultFont];
  playAgainLabel.text = @"Play Again";
  playAgainLabel.name = kPlayAgainNode;
  playAgainLabel.fontSize = 30.0;
  playAgainLabel.fontColor = [UIColor whiteColor];
  playAgainLabel.position = CGPointMake(CGRectGetMidX(self.frame), 150);
  [self addChild:playAgainLabel];
  
  SKLabelNode *quitLabel = [SKLabelNode labelNodeWithFontNamed:kDefaultFont];
  quitLabel.text = @"Quit";
  quitLabel.name = kQuitNode;
  quitLabel.fontSize = 30.0;
  quitLabel.fontColor = [UIColor whiteColor];
  quitLabel.position = CGPointMake(CGRectGetMidX(self.frame), 100);
  [self addChild:quitLabel];
}

- (void)didMoveToView:(SKView *)view {
  if (!_contentCreated) {
    [self _createSceneContent];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  
  if (touches.count == 1) {
    UITouch *touch = touches.anyObject;
    
    SKNode *node = [self nodeAtPoint:[touch locationInNode:self]];
    if (node.name == kPlayAgainNode) {
      [self runAction:[SKAction playSoundFileNamed:@"menu_select_15.wav" waitForCompletion:NO]];
      [self.view presentScene:[YKGameScene sceneWithSize:self.size] transition:[SKTransition fadeWithDuration:0.5]];
    }
    else if (node.name == kQuitNode) {
      [self runAction:[SKAction playSoundFileNamed:@"menu_select_15.wav" waitForCompletion:NO]];
      [self.view presentScene:[YKTitleScene sceneWithSize:self.size] transition:[SKTransition fadeWithDuration:0.5]];
    }
  }
}

@end
