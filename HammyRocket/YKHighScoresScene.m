//
//  YKHighScoresScene.m
//  HammyRocket
//
//  Created by Jim Liu on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKHighScoresScene.h"
#import "YKTitleScene.h"

static NSString *const kDefaultFont = @"Courier";

@implementation YKHighScoresScene {
  BOOL _contentCreated;
}

- (void)_createSceneContent {
  self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
  
  SKLabelNode *highScoresLabel = [SKLabelNode labelNodeWithFontNamed:kDefaultFont];
  highScoresLabel.text = @"High Scores";
  highScoresLabel.fontSize = 60.0;
  highScoresLabel.fontColor = [UIColor whiteColor];
  highScoresLabel.position = CGPointMake(CGRectGetMidX(self.frame), 900);
  [self addChild:highScoresLabel];
  
  SKLabelNode *back = [SKLabelNode labelNodeWithFontNamed:kDefaultFont];
  back.text = @"Tap anywhere to go back";
  back.fontSize = 20.0;
  back.fontColor = [UIColor whiteColor];
  back.position = CGPointMake(CGRectGetMidX(self.frame), 100);
  [self addChild:back];
}

- (void)didMoveToView:(SKView *)view {
  if (!_contentCreated) {
    [self _createSceneContent];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  
  [self.view presentScene:[YKTitleScene sceneWithSize:self.size] transition:[SKTransition fadeWithDuration:0.5]];
}

@end
