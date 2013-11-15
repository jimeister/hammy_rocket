//
//  YKLevelEvent.h
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKEnemyNode.h"
#import "YKPowerUp.h"

@interface YKLevelEnemyBirth : NSObject

@property (strong, nonatomic) YKEnemyNode *enemyNode;
@property (nonatomic) CGPoint birthPlace;  // y position relative to top of screen!!!

+ (YKLevelEnemyBirth *)enemyBirthWithNode:(YKEnemyNode *)node birthPlace:(CGPoint)birthPlace;

@end

@interface YKLevelPowerUpBirth : NSObject

@property (strong, nonatomic) YKPowerUp *powerUp;
@property (nonatomic) CGPoint birthPlace;

+ (YKLevelPowerUpBirth *)powerUpBirthWithNode:(YKPowerUp *)powerUp birthPlace:(CGPoint)birthPlace;

@end

@interface YKLevelEvent : NSObject

@property (strong, nonatomic) NSArray *enemies;
@property (strong, nonatomic) YKLevelPowerUpBirth *powerUp;

@end
