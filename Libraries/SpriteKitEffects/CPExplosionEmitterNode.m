//
//  CPExplosionEmitterNode.m
//  SpriteKitEffects
//
//  Created by Allen Cheung on 11/1/13.
//  Copyright (c) 2013 Allen Cheung. All rights reserved.
//

#import "CPExplosionEmitterNode.h"
#import "CPSimpleSpriteFactory.h"

static const CGFloat kDefaultExplosionEndingDiameter = 20.0;

@implementation CPExplosionEmitterNode

- (instancetype)init
{
    if ((self = [super init])) {
        self.particleBirthRate = 0;
        self.numParticlesToEmit = 0;
        
        self.particleLifetime = 3.0;
        self.particleLifetimeRange = 0.0;
        
        self.particleSpeed = 25.0;
        self.particleSpeedRange = 0.5;
        self.emissionAngle = M_PI_2;
        self.emissionAngleRange = 2 * M_PI;

        self.particleTexture = [SKTexture textureWithImage:[CPSimpleSpriteFactory circleImageWithDiameter:kDefaultExplosionEndingDiameter fillColor:[UIColor orangeColor] strokeColor:[UIColor orangeColor]]];
        self.particleSize = CGSizeMake(kDefaultExplosionEndingDiameter, kDefaultExplosionEndingDiameter);
        
        //self.particleScale = 0.0;
        //self.particleScaleSpeed = 1.0 / self.particleLifetime;
        
        self.particleAlpha = 0.5;
        self.particleAlphaSpeed = -self.particleAlpha / self.particleLifetime;
    }
    return self;
}

- (void)setCircleTextureDiameter:(CGFloat)diameter {
  self.particleTexture = [SKTexture textureWithImage:[CPSimpleSpriteFactory circleImageWithDiameter:diameter fillColor:[UIColor orangeColor] strokeColor:[UIColor orangeColor]]];
  self.particleSize = CGSizeMake(diameter, diameter);
}

- (void)setParticleLifetime:(CGFloat)particleLifetime {
  [super setParticleLifetime:particleLifetime];
  self.particleAlphaSpeed = -self.particleAlpha / self.particleLifetime;
}

- (void)explodeForDuration:(NSTimeInterval)duration
{
    self.particleBirthRate = 16.0;
    [self runAction:[SKAction waitForDuration:duration] completion:^() {
        self.particleBirthRate = 0.0;
        [self runAction:[SKAction waitForDuration:self.particleLifetime + self.particleLifetimeRange] completion:^() {
            [self removeFromParent];
        }];
    }];
}


@end
