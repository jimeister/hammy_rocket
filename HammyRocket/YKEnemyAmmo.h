//
//  YKEnemyAmmo.h
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

extern NSString *const YKEnemyAmmoName;

@interface YKEnemyAmmo : SKSpriteNode

@property (nonatomic) CGVector velocity;
@property (nonatomic, readonly) CGFloat hitRadius;

@end
