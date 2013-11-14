//
//  YKAirplaneNode.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKAirplaneNode.h"
#import "UIImage+YKUtils.h"

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

- (SKSpriteNode *)bodyNode {
  if (!_bodyNode) {
    _bodyNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:_images[0]]];
    _bodyNode.size = CGSizeMake(50, 50);
    [self addChild:_bodyNode];
  }
  return _bodyNode;
}

@end
