//
//  CPExplosionEmitterNode.h
//  SpriteKitEffects
//
//  Created by Allen Cheung on 11/1/13.
//  Copyright (c) 2013 Allen Cheung. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface CPExplosionEmitterNode : SKEmitterNode

@property (nonatomic) CGFloat duration;

- (void)setCircleTextureDiameter:(CGFloat)diameter;

- (void)explodeForDuration:(NSTimeInterval)duration;

@end
