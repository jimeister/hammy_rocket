//
//  YKIslandBackgroundLayer.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/15/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKIslandBackgroundLayer.h"
#import "UIImage+YKUtils.h"

@implementation YKIslandBackgroundLayer {
  NSArray *_images;
  CGFloat _speed;
  NSTimeInterval _timeAlive;
  NSInteger _currentIndex;
}

- (instancetype)init {
  if ((self = [super init])) {
    _images = [[self class] islandImages];
    _speed = 50;
    _timeAlive = 0;
    self.zPosition = -100;
  }
  return self;
}

+ (NSArray *)islandImages {
  static NSMutableArray *islandImages = nil;
  if (!islandImages) {
    islandImages = [[NSMutableArray alloc] initWithCapacity:3];
    UIImage *template = [UIImage imageNamed:@"1945.png"];
    for (NSInteger i = 0; i < 3; ++i) {
      UIImage *sprite = [template yk_imageByCroppingWithRect:CGRectMake(103 + 65*i, 499, 64, 65)];
      [islandImages addObject:sprite];
    }
  }
  return islandImages;
}

- (SKSpriteNode *)islandNodeWithImageAtIndex:(NSInteger)index {
  SKSpriteNode *node = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:_images[index]]];
  node.size = CGSizeMake(150, 150);
  node.name = @"Island";
  return node;
}

- (void)_addIslandOne {
  SKSpriteNode *node = [self islandNodeWithImageAtIndex:0];
  node.position = CGPointMake(100, CGRectGetHeight([[UIScreen mainScreen] bounds]) + 150);
  [self addChild:node];
}

- (void)_addIslandTwo {
  SKSpriteNode *node = [self islandNodeWithImageAtIndex:1];
  node.position = CGPointMake(550, CGRectGetHeight([[UIScreen mainScreen] bounds]) + 150);
  [self addChild:node];
}

- (void)_addIslandThree {
  SKSpriteNode *node = [self islandNodeWithImageAtIndex:2];
  node.position = CGPointMake(50, CGRectGetHeight([[UIScreen mainScreen] bounds]) + 150);
  [self addChild:node];
  node = [self islandNodeWithImageAtIndex:2];
  node.position = CGPointMake(150, CGRectGetHeight([[UIScreen mainScreen] bounds]) + 100);
  [self addChild:node];
}

- (void)_addIslandFour {
  SKSpriteNode *node = [self islandNodeWithImageAtIndex:1];
  node.size = CGSizeMake(300, 300);
  node.position = CGPointMake(800, CGRectGetHeight([[UIScreen mainScreen] bounds]) + 150);
  [self addChild:node];
}

- (void)_addIslandFive {
  SKSpriteNode *node = [self islandNodeWithImageAtIndex:2];
  node.position = CGPointMake(25, CGRectGetHeight([[UIScreen mainScreen] bounds]) + 100);
  [self addChild:node];
  node = [self islandNodeWithImageAtIndex:2];
  node.position = CGPointMake(125, CGRectGetHeight([[UIScreen mainScreen] bounds]) + 150);
  [self addChild:node];
}

- (void)_addIslandSix {
  SKSpriteNode *node = [self islandNodeWithImageAtIndex:0];
  node.size = CGSizeMake(200, 200);
  node.position = CGPointMake(75, CGRectGetHeight([[UIScreen mainScreen] bounds]) + 150);
  [self addChild:node];
}

- (void)_addIslandSeven {
  SKSpriteNode *node = [self islandNodeWithImageAtIndex:0];
  node.size = CGSizeMake(175, 175);
  node.position = CGPointMake(600, CGRectGetHeight([[UIScreen mainScreen] bounds]) + 150);
  [self addChild:node];
}

- (void)update:(NSTimeInterval)diff {
  if (diff < 2) {  // This is a hack =(
    _timeAlive += diff;
    
    NSInteger index = (NSInteger)_timeAlive % 50;
    
    if (index == 1 && index != _currentIndex) {
      [self _addIslandOne];
    } else if (index == 4 && index != _currentIndex) {
      [self _addIslandTwo];
    } else if (index == 9 && index != _currentIndex) {
      [self _addIslandThree];
    } else if (index == 15 && index != _currentIndex) {
      [self _addIslandFour];
    } else if (index == 21 && index != _currentIndex) {
      [self _addIslandFive];
    } else if (index == 23 && index != _currentIndex) {
      [self _addIslandSix];
    } else if (index == 30 && index != _currentIndex) {
      [self _addIslandThree];
    } else if (index == 35 && index != _currentIndex) {
      [self _addIslandOne];
    } else if (index == 39 && index != _currentIndex) {
      [self _addIslandSeven];
    }
    _currentIndex = index;
    
    [self enumerateChildNodesWithName:@"Island" usingBlock:^(SKNode *node, BOOL *stop) {
      node.position = CGPointMake(node.position.x, node.position.y - _speed * diff);
      if (node.position.y < -100) {
        [node removeFromParent];
      }
    }];
  }
}

@end
