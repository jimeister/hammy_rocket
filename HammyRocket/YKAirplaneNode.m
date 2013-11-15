//
//  YKAirplaneNode.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKAirplaneNode.h"
#import "UIImage+YKUtils.h"
#import "YKEnemyAmmo.h"

@interface YKAirplaneNode ()

@property (strong, nonatomic) SKSpriteNode *bodyNode;
@property (nonatomic) NSInteger style;
@property (strong, nonatomic) NSArray *images;

@end

@implementation YKAirplaneNode

@synthesize bodyNode=_bodyNode;

- (instancetype)initWithStyle:(NSInteger)style {
  if ((self = [super init])) {
    _style = style;
    _images = [[[self class] planeImages] objectAtIndex:_style];
    _bodyNode = self.bodyNode;
    self.velocity = CGVectorMake(0, -90);
    
    self.times = @[
                   @(1.1),
                   @(1.3),
                   @(1.5),
                   @(1.6),
                   @(1.7),
                   @(1.8)
                   ];
    self.events = @[
                    @"stop",
                    @"fireDown",
                    @"turnRightDown",
                    @"turnRight",
                    @"turnRightUp",
                    @"turnUp"
                    ];
  }
  return self;
}

+ (NSArray *)planeImages {
  static NSMutableArray *planeImages = nil;
  if (!planeImages) {
    planeImages = [[NSMutableArray alloc] initWithCapacity:5];
    UIImage *template = [UIImage imageNamed:@"1945.png"];
    for (int i = 0; i < 5; ++i) {
      NSMutableArray *rowImages = [NSMutableArray arrayWithCapacity:8];
      for (int j = 0; j < 8; ++j) {
        UIImage *sprite = [template yk_imageByCroppingWithRect:CGRectMake(4 + 33*j, 4 + 33*i, 32, 32)];
        [rowImages addObject:sprite];
      }
      [planeImages addObject:rowImages];
    }
  }
  return planeImages;
}

- (CGRect)frame {
  return CGRectMake(self.position.x - self.bodyNode.size.width/2, self.position.y - self.bodyNode.size.height/2,
                    self.bodyNode.size.width, self.bodyNode.size.height);
}

- (SKSpriteNode *)bodyNode {
  if (!_bodyNode) {
    _bodyNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:_images[0]]];
    _bodyNode.size = CGSizeMake(50, 50);
    [self addChild:_bodyNode];
  }
  return _bodyNode;
}

- (void)turnRightDown {
  _bodyNode.texture = [SKTexture textureWithImage:_images[1]];
  self.velocity = CGVectorMake(45, -45);
}

- (void)turnRight {
  _bodyNode.texture = [SKTexture textureWithImage:_images[2]];
  self.velocity = CGVectorMake(45, 0);
}

- (void)turnRightUp {
  _bodyNode.texture = [SKTexture textureWithImage:_images[3]];
  self.velocity = CGVectorMake(45, 45);
}

- (void)turnUp {
  _bodyNode.texture = [SKTexture textureWithImage:_images[4]];
  self.velocity = CGVectorMake(0, 45);
}

- (void)stop {
  self.velocity = CGVectorMake(0, 0);
}

- (void)fireDown {
  YKEnemyAmmo *ammo = [[YKEnemyAmmo alloc] init];
  ammo.position = self.position;
  ammo.zPosition = self.zPosition - 1;
  ammo.velocity = CGVectorMake(0, -70);
  [self.scene addChild:ammo];
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
