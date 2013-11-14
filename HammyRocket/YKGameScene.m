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
  

}

- (void)didMoveToView:(SKView *)view {
  if (!_contentCreated) {
    [self _createSceneContent];
  }
}

@end
