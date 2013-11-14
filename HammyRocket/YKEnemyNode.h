//
//  YKEnemyNode.h
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "YKEnemyAmmo.h"

extern NSString *const YKEnemyNodeName;

@interface YKEnemyNode : SKNode

@property (nonatomic) CGVector velocity;
@property (readonly, nonatomic) YKEnemyAmmo *ammo;

// Public for subclasses, clients shouldn't touch
@property (nonatomic) NSTimeInterval timeAlive;
@property (nonatomic) NSInteger eventIndex;

- (void)update:(NSTimeInterval)diff;

@end
