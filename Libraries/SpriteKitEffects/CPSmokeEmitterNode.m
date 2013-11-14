//
//  CPSmokeEmitterNode.m
//  SpriteKitEffects
//
//  Created by Allen Cheung on 10/24/13.
//  Copyright (c) 2013 Allen Cheung. All rights reserved.
//

#import "CPSmokeEmitterNode.h"
#import "CPSimpleSpriteFactory.h"

static const CGFloat kDefaultSmokePuffEndingDiameter = 30.0;
static const CGFloat kDefaultSmokePuffStartingDiameter = 5.0;
static const CGFloat kDefaultSmokePuffLifetime = 10.0;
static const CGFloat kDefaultSmokePuffBirthRate = 4.0;

@implementation CPSmokeEmitterNode

- (instancetype)init
{
    if ((self = [super init])) {
        self.particleBirthRate = kDefaultSmokePuffBirthRate;
        self.numParticlesToEmit = 0;
        
        self.particleLifetime = kDefaultSmokePuffLifetime;
        self.particleLifetimeRange = 1;
        
        self.particleSpeed = 10.0;
        self.particleSpeedRange = 0.5;
        self.emissionAngle = M_PI_2;
        self.emissionAngleRange = M_PI_4 * 0.75;
        
        self.particleTexture = [SKTexture textureWithImage:[CPSimpleSpriteFactory circleImageWithDiameter:kDefaultSmokePuffEndingDiameter fillColor:[UIColor whiteColor] strokeColor:[UIColor whiteColor]]];
        self.particleSize = CGSizeMake(kDefaultSmokePuffEndingDiameter, kDefaultSmokePuffEndingDiameter);
        
        self.particleScale = 0.0;
        self.particleScaleSpeed = 1.0 / self.particleLifetime;
        
        self.particleAlpha = 0.5;
        self.particleAlphaSpeed = -0.05;
    }
    return self;
}

@end
