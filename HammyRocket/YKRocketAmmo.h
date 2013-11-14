//
//  YKRocketAmmo.h
//  HammyRocket
//
//  Created by Jim Liu on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface YKRocketAmmo : SKNode

- (instancetype)initWithFireRate:(CGFloat)rate;
- (void)createFireAction;

@property (nonatomic, strong) SKSpriteNode *ammo;
@property (nonatomic, strong) SKAction *fire;
@property (nonatomic) CGFloat ammoVelocity;

@end
