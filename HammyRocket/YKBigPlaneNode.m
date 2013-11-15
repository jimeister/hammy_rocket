//
//  YKBigPlaneNode.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKBigPlaneNode.h"
#import "UIImage+YKUtils.h"

@interface YKBigPlaneNode ()

@property (strong, nonatomic) SKSpriteNode *bodyNode;
@property (strong, nonatomic) NSArray *images;

@end


@implementation YKBigPlaneNode {
  NSInteger _imageIndex;
}

@synthesize bodyNode=_bodyNode;

- (instancetype)init {
  if ((self = [super init])) {
    _images = [[self class] planeImages];
    _bodyNode = self.bodyNode;
    
    self.baseSpeed = 50;
    self.times = @[@(0.1), @(3), @(8)];
    self.events = @[@"moveDown", @"stop", @"moveUp"];
    self.health = 20;
  }
  return self;
}

- (CGRect)frame {
  return CGRectMake(self.position.x - self.bodyNode.size.width/2, self.position.y - self.bodyNode.size.height/2,
                    self.bodyNode.size.width, self.bodyNode.size.height);
}

+ (NSArray *)planeImages {
  static NSMutableArray *planeImages = nil;
  if (!planeImages) {
    planeImages = [[NSMutableArray alloc] initWithCapacity:3];
    UIImage *template = [UIImage imageNamed:@"bigplane.png"];
    for (NSInteger i = 0; i < 3; ++i) {
      UIImage *sprite = [template yk_imageByCroppingWithRect:CGRectMake(4 + 99*i, 15, 93, 74)];
      [planeImages addObject:sprite];
    }
  }
  return planeImages;
}

- (NSInteger)_nextImageIndex {
  _imageIndex++;
  _imageIndex %= 3;
  return _imageIndex;
}

- (void)_spin {
  SKAction *sequence = [SKAction sequence: @[
                                             [SKAction waitForDuration:0.05],
                                             [SKAction setTexture:[SKTexture textureWithImage:_images[[self _nextImageIndex]]]],
                                             ]];
  [_bodyNode runAction:sequence completion:^() {
    [self _spin];
  }];
}

- (void)moveDown {
  self.velocity = CGVectorMake(0, -self.baseSpeed);
}

- (void)moveUp {
  self.velocity = CGVectorMake(0, self.baseSpeed / 2);
}

- (void)stop {
  self.velocity = CGVectorMake(0, 0);
}

- (SKSpriteNode *)bodyNode {
  if (!_bodyNode) {
    _bodyNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:_images[0]]];
    _bodyNode.size = CGSizeMake(93*1.8, 74*1.8);
    [self _spin];
    [self addChild:_bodyNode];
  }
  return _bodyNode;
}

- (void)update:(NSTimeInterval)diff {
  [super update:diff];
  
  if (self.eventIndex < self.times.count && self.timeAlive > [self.times[self.eventIndex] floatValue]) {
    NSString *selectorName = self.events[self.eventIndex];
    [self performSelector:NSSelectorFromString(selectorName)];
    self.eventIndex++;
  }
}

@end
