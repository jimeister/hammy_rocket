//
//  YKLivesNodes.h
//  HammyRocket
//
//  Created by Jim Liu on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface YKLivesNodes : SKNode

- (instancetype)initWithMaxLives:(NSInteger)lives;
- (void)decrementLife;

@property (readonly, nonatomic) NSInteger numLives;

@end
