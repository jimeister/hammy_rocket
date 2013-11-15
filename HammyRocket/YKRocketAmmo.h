//
//  YKRocketAmmo.h
//  HammyRocket
//
//  Created by Jim Liu on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

extern NSString *const YKAmmoName;

@interface YKAmmoSprite : SKSpriteNode
@property (nonatomic) CGVector ammoDirection;
@end

@interface YKRocketAmmo : SKNode

- (instancetype)initWithFireRate:(CGFloat)rate;
- (void)createFireAction;

@property (nonatomic, strong) SKSpriteNode *ammo;
@property (nonatomic, strong) SKAction *fire;
@property (nonatomic) CGFloat ammoVelocity;
@property (nonatomic) NSUInteger damage;
@property (nonatomic) BOOL upgradeAmmo;

@end
