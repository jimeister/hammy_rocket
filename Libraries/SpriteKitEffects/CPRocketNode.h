//
//  CPRocketNode.h
//  SpriteKitEffects
//
//  Created by Allen Cheung on 10/29/13.
//  Copyright (c) 2013 Allen Cheung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPRocketNode : SKNode

@property (strong, nonatomic) SKTexture *bodyTexture;
@property (strong, nonatomic) SKTexture *exhaustParticleTexture;
@property (nonatomic) CGFloat exhaustParticleLifetime;
@property (nonatomic) CGVector velocity;
@property (nonatomic) CGFloat exhaustEmissionAngleRange;

/*
 @param seconds Number of seconds for action to move
 @returns An SKAction to move by the current velocity for a given time interval
 */
- (SKAction *)actionToMoveWithVelocityForSeconds:(NSTimeInterval)seconds;

/*
 @param seconds Number of seconds to move
 @param completion Block to execute when move is finished
 */
- (void)moveForSeconds:(NSTimeInterval)seconds completion:(void (^)())completion;

- (void)moveToPoint:(CGPoint)point speed:(CGFloat)speed completion:(void (^)())completion;

/*
 Remove the body node and stop emitting from the exhaust node.  Remove self
 once the last particle lifetime has expired.
 */
- (void)terminate;

@end
