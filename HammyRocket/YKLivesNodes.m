//
//  YKLivesNodes.m
//  HammyRocket
//
//  Created by Jim Liu on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKLivesNodes.h"

@interface YKLivesNodes ()
@property (nonatomic, strong) NSMutableArray *lifeNodes;
@end

@implementation YKLivesNodes

- (instancetype)initWithMaxLives:(NSInteger)lives {
  if ((self = [super init])) {
    _lives = lives;
    [self _createLifeNodes];
  }
  return self;
}

- (void)_createLifeNodes {
  
}

@end
