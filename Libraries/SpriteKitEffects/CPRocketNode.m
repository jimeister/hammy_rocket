//
//  CPRocketNode.m
//  SpriteKitEffects
//
//  Created by Allen Cheung on 10/29/13.
//  Copyright (c) 2013 Allen Cheung. All rights reserved.
//

#import "CPRocketNode.h"
#import "CPMath.h"

#define kDefaultExhaustBirthRate (5)
#define kDefaultExhaustLifetime (5)

@interface CPRocketNode ()

@property (readonly, nonatomic) SKSpriteNode *bodyNode;
@property (readonly, nonatomic) SKEmitterNode *exhaustNode;

@end

@implementation CPRocketNode

@synthesize bodyNode=_bodyNode, exhaustNode=_exhaustNode;

- (instancetype)init
{
    if ((self = [super init])) {
    }
    return self;
}

- (SKSpriteNode *)bodyNode
{
    if (!_bodyNode) {
        _bodyNode = [[SKSpriteNode alloc] initWithTexture:self.bodyTexture];
        [self addChild:_bodyNode];
    }
    return _bodyNode;
}

- (SKEmitterNode *)exhaustNode
{
    if (!_exhaustNode) {
        _exhaustNode = [[SKEmitterNode alloc] init];
        _exhaustNode.particleBirthRate = kDefaultExhaustBirthRate;
        _exhaustNode.particleLifetime = kDefaultExhaustLifetime;
      _exhaustNode.zPosition = -1;
        [self addChild:_exhaustNode];
    }
    return _exhaustNode;
}

- (void)setBodyTexture:(SKTexture *)bodyTexture
{
    _bodyTexture = bodyTexture;
    self.bodyNode.texture = bodyTexture;
}

- (void)setBodySize:(CGSize)size {
  self.bodyNode.size = size;
}

- (void)setExhaustParticleTexture:(SKTexture *)exhaustParticleTexture
{
    _exhaustParticleTexture = exhaustParticleTexture;
    self.exhaustNode.particleTexture = exhaustParticleTexture;
    self.exhaustNode.particleSize = exhaustParticleTexture.size;
}

- (void)setExhaustParticleLifetime:(CGFloat)lifetime
{
    _exhaustParticleLifetime = lifetime;
    self.exhaustNode.particleLifetime = lifetime;
    self.exhaustNode.particleAlphaSpeed = -(self.exhaustNode.particleAlpha / self.exhaustNode.particleLifetime);
}

- (void)setVelocity:(CGVector)velocity
{
    _velocity = velocity;
    CGVector exhaustVelocity = CGVectorMake(-velocity.dx, -velocity.dy);
    CGFloat exhaustAngle = CPCGVectorAngleInRadians(exhaustVelocity);
    CGFloat exhaustMagnitude = CPCGVectorMagnitude(exhaustVelocity);
    self.exhaustNode.emissionAngle = exhaustAngle;
    self.exhaustNode.particleSpeed = exhaustMagnitude;
}

- (void)setExhaustEmissionAngleRange:(CGFloat)exhaustEmissionAngleRange
{
    self.exhaustNode.emissionAngleRange = exhaustEmissionAngleRange;
}

- (SKAction *)actionToMoveWithVelocityForSeconds:(NSTimeInterval)seconds
{
    return [SKAction moveBy:CGVectorMake(self.velocity.dx * seconds, self.velocity.dy * seconds) duration:seconds];
}

- (void)moveForSeconds:(NSTimeInterval)seconds completion:(void (^)())completion
{
    SKAction *moveAction = [self actionToMoveWithVelocityForSeconds:seconds];
    [self runAction:moveAction completion:completion];
}

- (void)moveToPoint:(CGPoint)point speed:(CGFloat)speed completion:(void (^)())completion
{
    CGVector travelDistance = CGVectorMake(point.x - self.position.x, point.y - self.position.y);
    NSTimeInterval duration = CPCGVectorMagnitude(travelDistance) / speed;
    self.velocity = CGVectorMake(travelDistance.dx / duration, travelDistance.dy / duration);
    [self moveForSeconds:duration completion:completion];
}

- (void)terminate
{
    [self.bodyNode removeFromParent];
    self.exhaustNode.particleBirthRate = 0.0;
    self.exhaustNode.particleSpeed = 0.0;
    SKAction *action = [SKAction waitForDuration:self.exhaustNode.particleLifetime + self.exhaustNode.particleLifetimeRange];
    [self runAction:action completion:^() {
        [self removeFromParent];
    }];
}

@end
