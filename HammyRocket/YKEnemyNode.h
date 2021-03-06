//
//  YKEnemyNode.h
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "YKEnemyAmmo.h"
#import "YKPowerUp.h"

extern NSString *const YKEnemyNodeName;

@interface YKEnemyNode : SKNode

@property (nonatomic) CGVector velocity;
@property (readonly, nonatomic) YKEnemyAmmo *ammo;
@property (nonatomic) NSInteger health;
@property (nonatomic) NSInteger damage;
@property (readonly, nonatomic) YKPowerUp *powerUp;
@property (nonatomic) NSInteger score; // For killing enemy
@property (nonatomic) CGFloat baseSpeed;
@property (nonatomic) CGFloat ammoSpeed;
@property (nonatomic) BOOL dead;

// Events
@property (strong, nonatomic) NSArray *times;
@property (strong, nonatomic) NSArray *events;

// Public for subclasses, clients shouldn't touch
@property (nonatomic) NSTimeInterval timeAlive;
@property (nonatomic) NSInteger eventIndex;

- (void)fireAtPlayer;

- (void)update:(NSTimeInterval)diff;

- (void)die;

@end
