//
//  YKTitleScene.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKTitleScene.h"
#import "YKGameScene.h"
#import "YKInstructionsScene.h"
#import "YKHighScoresScene.h"
#import "YKHammyRocket.h"
#import "YKAirplaneNode.h"

static NSString *const kDefaultFont = @"Courier";
static NSString *const kStartNode = @"kStartNode";
static NSString *const kHighScores = @"kHighScores";
static NSString *const kInstructions = @"kInstructions";

@implementation YKTitleScene {
  BOOL _contentCreated;
  YKHammyRocket *_rocket;
  YKAirplaneNode *_airplane;
}

- (void)_createSceneContent {
  self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
  
  SKSpriteNode *logo = [[SKSpriteNode alloc] initWithImageNamed:@"yelp_logo.png"];
  logo.position = CGPointMake(CGRectGetMidX(self.frame), 100);
  [self addChild:logo];
  
  SKLabelNode *startLabel = [SKLabelNode labelNodeWithFontNamed:kDefaultFont];
  startLabel.text = @"Start";
  startLabel.name = kStartNode;
  startLabel.fontSize = 60.0;
  startLabel.fontColor = [UIColor whiteColor];
  startLabel.position = CGPointMake(CGRectGetMidX(self.frame), 250);
  [self addChild:startLabel];
  
  SKLabelNode *instructionsLabel = [SKLabelNode labelNodeWithFontNamed:kDefaultFont];
  instructionsLabel.text = @"Instructions";
  instructionsLabel.name = kInstructions;
  instructionsLabel.fontSize = 30.0;
  instructionsLabel.fontColor = [UIColor whiteColor];
  instructionsLabel.position = CGPointMake(CGRectGetMidX(self.frame), 200);
  [self addChild:instructionsLabel];
  
  SKLabelNode *highScoresLabel = [SKLabelNode labelNodeWithFontNamed:kDefaultFont];
  highScoresLabel.text = @"High Scores";
  highScoresLabel.name = kHighScores;
  highScoresLabel.fontSize = 30.0;
  highScoresLabel.fontColor = [UIColor whiteColor];
  highScoresLabel.position = CGPointMake(CGRectGetMidX(self.frame), 150);
  [self addChild:highScoresLabel];
  
  SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:kDefaultFont];
  titleLabel.text = @"Hammy In Space";
  titleLabel.fontSize = 60.0;
  titleLabel.fontColor = [UIColor whiteColor];
  titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), 900);
  [self addChild:titleLabel];
  
  _rocket = [[YKHammyRocket alloc] init];
  _rocket.position = CGPointMake(CGRectGetMidX(self.frame), 350);
  SKAction *hover = [SKAction sequence:@[[SKAction moveByX:200 y:100 duration:3.0],
                                         [SKAction moveByX:-200 y:100 duration:3.0],
                                         [SKAction moveByX:-200 y:-100 duration:3.0],
                                         [SKAction moveByX:200 y:-100 duration:3.0]
                                         ]];
  [_rocket runAction:[SKAction repeatActionForever:hover]];
  [self addChild:_rocket];
  
  _airplane = [[YKAirplaneNode alloc] initWithStyle:0];
  _airplane.position = CGPointMake(CGRectGetMidX(self.frame), 800);
  SKAction *hover2 = [SKAction sequence:@[[SKAction moveByX:300 y:0 duration:2.0],
                                          [SKAction moveByX:-600 y:0 duration:4.0],
                                          [SKAction moveByX:300 y:0 duration:2.0],
                                          [SKAction moveByX:0 y:-100 duration:1.5],
                                          [SKAction moveByX:0 y:100 duration:1.5]
                                          ]];
  [_airplane runAction:[SKAction repeatActionForever:hover2]];
  [self addChild:_airplane];
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

- (void)_showInstructions {
  SKScene *instructionsScene = [[YKInstructionsScene alloc] initWithSize:self.size];
  [self.view presentScene:instructionsScene transition:[SKTransition fadeWithDuration:0.5]];
}

- (void)_showHighScores {
  SKScene *highScoresScene = [[YKHighScoresScene alloc] initWithSize:self.size];
  [self.view presentScene:highScoresScene transition:[SKTransition fadeWithDuration:0.5]];
}

#pragma mark UIResponder

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  
  if (touches.count == 1) {
    UITouch *touch = touches.anyObject;
    
    SKNode *node = [self nodeAtPoint:[touch locationInNode:self]];
    if (node.name == kStartNode) {
      [self runAction:[SKAction playSoundFileNamed:@"menu_select_15.wav" waitForCompletion:NO]];
      [self _startGame];
    }
    else if (node.name == kInstructions) {
      [self runAction:[SKAction playSoundFileNamed:@"menu_select_15.wav" waitForCompletion:NO]];
      [self _showInstructions];
    }
    else if (node.name == kHighScores) {
      [self runAction:[SKAction playSoundFileNamed:@"menu_select_15.wav" waitForCompletion:NO]];
      [self _showHighScores];
    }
  }
}

@end
