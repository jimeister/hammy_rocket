//
//  YKEnemyNode.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKEnemyNode.h"

NSString *const YKEnemyNodeName = @"YKEnemyNodeName";

@implementation YKEnemyNode

- (instancetype)init {
  if ((self = [super init])) {
    self.name = YKEnemyNodeName;
  }
  return self;
}

@end
