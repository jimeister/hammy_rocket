//
//  YKCloudBackgroundLayer.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/15/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKCloudBackgroundLayer.h"
#define ARC4RANDOM_MAX 0x100000000

@implementation YKCloudBackgroundLayer {
  CGFloat _speed;
  CGFloat _timeAlive;
  CGFloat _cloudGenTime;
}

- (instancetype)init {
  if ((self = [super init])) {
    self.zPosition = -99;
    _speed = 100;
    _timeAlive = 0;
    _cloudGenTime = (CGFloat)(arc4random() % 30) / 10;
  }
  return self;
}

+ (UIImage *)cloudImage {
  static UIImage *image = nil;
  if (!image) {
    image = [UIImage imageNamed:@"cloud_front.png"];
  }
  return image;
}

- (SKSpriteNode *)cloudNodeWithScale:(CGFloat)scale name:(NSString *)name {
  SKSpriteNode *node = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[[self class] cloudImage]]];
  node.alpha = 0.6;
  node.size = CGSizeMake(node.size.width * scale, node.size.height * scale);
  node.name = name;
  node.position = CGPointMake(arc4random() % 750, CGRectGetHeight([[UIScreen mainScreen] bounds]) + 100);
  return node;
}

- (void)update:(NSTimeInterval)diff {
  if (diff < 2) {  // This is a hack =(
    _timeAlive += diff;
    _cloudGenTime -= diff;
    if (_cloudGenTime < 0) {
      _cloudGenTime = (CGFloat)(arc4random() % 30) / 10;
      int32_t cloudType = arc4random() % 3;
      if (cloudType == 0) {
        SKSpriteNode *node = [self cloudNodeWithScale:1.0 name:@"Cloud"];
        [self addChild:node];
      } else if (cloudType == 1) {
        SKSpriteNode *node = [self cloudNodeWithScale:1.5 name:@"FastCloud"];
        [self addChild:node];
      } else if (cloudType == 2) {
        SKSpriteNode *node = [self cloudNodeWithScale:0.8 name:@"SlowCloud"];
        [self addChild:node];
      }
    }
    
    [self enumerateChildNodesWithName:@"Cloud" usingBlock:^(SKNode *node, BOOL *stop) {
      node.position = CGPointMake(node.position.x, node.position.y - _speed * diff);
      if (node.position.y < -100) {
        [node removeFromParent];
      }
    }];
    [self enumerateChildNodesWithName:@"FastCloud" usingBlock:^(SKNode *node, BOOL *stop) {
      node.position = CGPointMake(node.position.x, node.position.y - _speed * 1.5 * diff);
      if (node.position.y < -100) {
        [node removeFromParent];
      }
    }];
    [self enumerateChildNodesWithName:@"SlowCloud" usingBlock:^(SKNode *node, BOOL *stop) {
      node.position = CGPointMake(node.position.x, node.position.y - _speed * 0.8 * diff);
      if (node.position.y < -100) {
        [node removeFromParent];
      }
    }];
  }
}

@end
