//
//  YKHammyRocket.h
//  HammyRocket
//
//  Created by Jim Liu on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface YKHammyRocket : SKNode

- (void)createHammyRocketAtPosition:(CGPoint)position;

@property (nonatomic, strong) SKSpriteNode *rocket;
@property (nonatomic, strong) SKSpriteNode *rocket_interior;
@property (nonatomic, strong) SKSpriteNode *hammy;

@end