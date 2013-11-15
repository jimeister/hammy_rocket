//
//  YKSpriteViewController.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKSpriteViewController.h"
#import "YKTitleScene.h"

@interface YKSpriteViewController ()

@end

@implementation YKSpriteViewController

- (void)loadView {
  [super loadView];
  self.view = [[SKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  SKView *view = (SKView *)self.view;
  view.ignoresSiblingOrder = YES;
  
  SKScene *scene = [YKTitleScene sceneWithSize:view.bounds.size];
  scene.scaleMode = SKSceneScaleModeAspectFill;
  
  [view presentScene:scene];
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}

@end
