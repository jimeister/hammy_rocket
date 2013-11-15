//
//  YKInstructionsScene.m
//  HammyRocket
//
//  Created by Jim Liu on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKInstructionsScene.h"
#import "YKTitleScene.h"

static NSString *const kDefaultFont = @"Courier";

@implementation YKInstructionsScene {
  BOOL _contentCreated;
}

- (void)_createSceneContent {
  self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
  
  SKLabelNode *line1 = [SKLabelNode labelNodeWithFontNamed:kDefaultFont];
  line1.text = @"Drag your finger to move hammy.";
  line1.fontSize = 30.0;
  line1.fontColor = [UIColor whiteColor];
  line1.position = CGPointMake(CGRectGetMidX(self.frame), 900);
  [self addChild:line1];
  
  SKLabelNode *line2 = [SKLabelNode labelNodeWithFontNamed:kDefaultFont];
  line2.text = @"Get power ups for your rocket!";
  line2.fontSize = 30.0;
  line2.fontColor = [UIColor whiteColor];
  line2.position = CGPointMake(CGRectGetMidX(self.frame), 850);
  [self addChild:line2];
  
  SKLabelNode *line3 = [SKLabelNode labelNodeWithFontNamed:kDefaultFont];
  line3.text = @"Avoid enemy fire and blow them up!";
  line3.fontSize = 30.0;
  line3.fontColor = [UIColor whiteColor];
  line3.position = CGPointMake(CGRectGetMidX(self.frame), 800);
  [self addChild:line3];
  
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
  [self runAction:[SKAction playSoundFileNamed:@"menu_select_15.wav" waitForCompletion:NO]];
  [self.view presentScene:[YKTitleScene sceneWithSize:self.size] transition:[SKTransition fadeWithDuration:0.5]];
}

@end
