//
//  YKGameScene.h
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "YKHammyRocket.h"
#import "YKRocketAmmo.h"

@interface YKGameScene : SKScene

@property (nonatomic, strong) YKHammyRocket *rocket;
@property (nonatomic, strong) YKRocketAmmo *ammo;

@end
