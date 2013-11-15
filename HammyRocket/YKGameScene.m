//
//  YKGameScene.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/14/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKGameScene.h"
#import "YKAirplaneNode.h"
#import "CPMath.h"
#import "YKLevelScheduler.h"
#import "YKEnemyNode.h"
#import "CPExplosionEmitterNode.h"
#import "CPSimpleSpriteFactory.h"
#import "YKEnemyAmmo.h"
#import "YKTitleScene.h"
#import "YKGameOverScene.h"

#define ARC4RANDOM_MAX 0x100000000
#define MAX_LIVES (3)

static NSString *const kDefaultFont = @"Courier";
static NSString *const kScoreNodeName = @"kScoreNodeName";

@interface YKGameScene ()
@property (strong, nonatomic) YKLevelScheduler *scheduler;
@property (strong, nonatomic) SKNode *scoreLayer;
@end

@implementation YKGameScene {
  
  NSUInteger _score;
  BOOL _contentCreated;
  NSTimeInterval _lastUpdateTime;
  BOOL _touched;
  BOOL _canFire;
  CGPoint _lastTouch;
}

@synthesize scheduler=_scheduler;

- (YKLevelScheduler *)scheduler {
  if (!_scheduler) {
    _scheduler = [[YKLevelScheduler alloc] init];
  }
  return _scheduler;
}

- (void)_createSceneContent {
  self.backgroundColor = [SKColor colorWithRed:0.0 green:0.0 blue:0.3 alpha:1.0];
  _lastUpdateTime = 0.0;
  
  _rocket = [[YKHammyRocket alloc] init];
  _rocket.position = CGPointMake(CGRectGetMidX(self.frame), 100);
  _rocket.zPosition = -5;
  [self addChild:self.rocket];
  
  _lives = [[YKLivesNodes alloc] initWithMaxLives:MAX_LIVES];
  _lives.position = CGPointMake(CGRectGetMinX(self.frame) + 30, CGRectGetMaxY(self.frame) - 25);
  _lives.zPosition = 10;
  [self addChild:self.lives];
  
  _ammo = [[YKRocketAmmo alloc] initWithFireRate:0.20];
  [self.ammo createFireAction];
  [self addChild:self.ammo];
  
  _scoreLayer = [[SKNode alloc] init];
  [self addChild:_scoreLayer];

  SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:kDefaultFont];
  scoreLabel.text = @"0";
  scoreLabel.name = kScoreNodeName;
  scoreLabel.fontSize = 30.0;
  scoreLabel.fontColor = [UIColor whiteColor];
  scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
  scoreLabel.position = CGPointMake(CGRectGetMaxX(self.frame) - 30, CGRectGetMaxY(self.frame) - 30);
  [_scoreLayer addChild:scoreLabel];
}

- (void)didMoveToView:(SKView *)view {
  if (!_contentCreated) {
    [self _createSceneContent];
    _contentCreated = YES;
  }
}
  
- (void)_handlePlayerMoveWithDiff:(NSTimeInterval)diff {
  if (_touched) {
    CGFloat rocketVelocity = _rocket.maxVelocity * diff;
    CGPoint rocketPosition = _rocket.position;
    CGVector direction = CGVectorMake(_lastTouch.x - rocketPosition.x, _lastTouch.y - rocketPosition.y);
    CGFloat scale = MIN(rocketVelocity / CPCGVectorMagnitude(direction), 1.0);
    CGVector velocity = CGVectorMake(direction.dx * scale, direction.dy * scale);
    _rocket.position = CGPointMake(rocketPosition.x + velocity.dx, rocketPosition.y + velocity.dy);
  }
}

- (void)_addSmallHitAtPosition:(CGPoint)position overNode:(SKNode *)node {
  CPExplosionEmitterNode *smallHit = [[CPExplosionEmitterNode alloc] init];
  smallHit.particleTexture = [SKTexture textureWithImage:[CPSimpleSpriteFactory starImageWithOuterRadius:24.0 innerRadius:13.0 fillColor:[UIColor orangeColor] strokeColor:[UIColor orangeColor]]];
  smallHit.particleSize = CGSizeMake(20.0, 20.0);
  smallHit.zPosition = node.zPosition + 1;
  smallHit.position = position;
  smallHit.particleLifetime =
  smallHit.yAcceleration = 10.0;
  smallHit.particleLifetime = 1.0;
  [smallHit advanceSimulationTime:0.5];
  [self addChild:smallHit];
  [smallHit explodeForDuration:0.1];
}

- (void)_addLargeHitAtPosition:(CGPoint)position overNode:(SKNode *)node {
  CPExplosionEmitterNode *hit = [[CPExplosionEmitterNode alloc] init];
  hit.particleTexture = [SKTexture textureWithImage:[CPSimpleSpriteFactory starImageWithOuterRadius:24.0 innerRadius:13.0 fillColor:[UIColor orangeColor] strokeColor:[UIColor orangeColor]]];
  hit.particleSize = CGSizeMake(30.0, 30.0);
  hit.zPosition = node.zPosition + 1;
  hit.position = position;
  hit.particleLifetime =
  hit.yAcceleration = 10.0;
  hit.particleLifetime = 1.5;
  [hit advanceSimulationTime:0.5];
  [self addChild:hit];
  [hit explodeForDuration:0.2];
}

- (void)_updateAmmoPositionsWithDiff:(NSTimeInterval)diff {
  [self.ammo enumerateChildNodesWithName:@"ammo" usingBlock:^(SKNode *ammoNode, BOOL *stop) {
    if (CGPointEqualToPoint(ammoNode.position, CGPointMake(0, 0))) {
      ammoNode.position = CGPointMake(_rocket.position.x, _rocket.position.y + 40);
    }
    else {
      CGFloat ammoVelocity = self.ammo.ammoVelocity * diff;
      CGPoint position = ammoNode.position;
      ammoNode.position = CGPointMake(position.x, position.y + ammoVelocity);
    }
    
    if (ammoNode.position.y > self.frame.size.height) {
      [ammoNode removeFromParent];
    }
    
    [self enumerateChildNodesWithName:YKEnemyNodeName usingBlock:^(SKNode *node, BOOL *stop) {
      if (ammoNode.position.x > CGRectGetMinX(node.frame) && ammoNode.position.x < CGRectGetMaxX(node.frame) &&
          ammoNode.position.y > CGRectGetMinY(node.frame) && ammoNode.position.y < CGRectGetMaxY(node.frame)) {

        [self _addSmallHitAtPosition:ammoNode.position overNode:node];
        [ammoNode removeFromParent];
        
        YKEnemyNode *enemyNode = (YKEnemyNode *)node;
        enemyNode.health -= self.ammo.damage;
        if (enemyNode.health <= 0) {
          _score += enemyNode.score;
          SKLabelNode *scoreLabel = (SKLabelNode *)[_scoreLayer childNodeWithName:kScoreNodeName];
          scoreLabel.text = [@(_score) description];
          
          [enemyNode removeFromParent];
          CPExplosionEmitterNode *explosion = [[CPExplosionEmitterNode alloc] init];
          explosion.position = enemyNode.position;
          [explosion advanceSimulationTime:5.0];
          [self addChild:explosion];
          [explosion explodeForDuration:0.4];
        }
      }
    }];
  }];
}

- (void)_showGameOver {
  [self.view presentScene:[YKGameOverScene sceneWithSize:self.size] transition:[SKTransition fadeWithDuration:0.5]];
}

- (void)update:(NSTimeInterval)currentTime {
  NSTimeInterval diff = currentTime - _lastUpdateTime;
  
  [self _handlePlayerMoveWithDiff:diff];
  if (_touched && _canFire) {
    _canFire = NO;
    [self.rocket runAction:self.ammo.fire completion:^() {
      _canFire = YES;
    }];
  }
  
  // Update ammo position here
  [self _updateAmmoPositionsWithDiff:diff];
  
  // Enemy ammo position
  [self enumerateChildNodesWithName:YKEnemyAmmoName usingBlock:^(SKNode *node, BOOL *stop) {
    YKEnemyAmmo *ammo = (YKEnemyAmmo *)node;
    ammo.position = CGPointMake(ammo.position.x + ammo.velocity.dx * diff, ammo.position.y + ammo.velocity.dy * diff);
    
    CGFloat distanceToHammy = CPCGPointDistance(ammo.position, _rocket.position);
    if (distanceToHammy < ammo.hitRadius + _rocket.hitRadius) {
      [self _addLargeHitAtPosition:ammo.position overNode:_rocket];
      [ammo removeFromParent];
      
      _rocket.health--;
      if (_rocket.health == 0) {
        CPExplosionEmitterNode *explosion = [[CPExplosionEmitterNode alloc] init];
        explosion.position = _rocket.position;
        [explosion advanceSimulationTime:5.0];
        [self addChild:explosion];
        [explosion explodeForDuration:1.0];
        
        [_rocket removeFromParent];
        if (self.lives.numLives > 0) {
          [[self.lives.children lastObject] removeFromParent];
          [self.lives decrementLife];
        }
        
        if (self.lives.numLives > 0) {
          // Respawn
          _touched = NO;
          _canFire = NO;
          _lastTouch = CGPointZero;
          _rocket = [[YKHammyRocket alloc] init];
          _rocket.position = CGPointMake(CGRectGetMidX(self.frame), -20);
          _rocket.zPosition = -5;
          self.userInteractionEnabled = NO;
          [self addChild:self.rocket];
          SKAction *moveFromBottom = [SKAction moveTo:CGPointMake(CGRectGetMidX(self.frame), 100) duration:1.0];
          [self.rocket runAction:moveFromBottom completion:^(void) {
            self.userInteractionEnabled = YES;
          }];
        }
        else {
          [self _showGameOver];
        }
      }
    }
  }];

  YKLevelEvent *event = [self.scheduler eventForCurrentTime:currentTime];
  for (YKLevelEnemyBirth *enemyBirth in event.enemies) {
    enemyBirth.enemyNode.position = CGPointMake(enemyBirth.birthPlace.x, enemyBirth.birthPlace.y + CGRectGetMaxY(self.frame));
    [self addChild:enemyBirth.enemyNode];
  }
  
  [self enumerateChildNodesWithName:YKEnemyNodeName usingBlock:^(SKNode *node, BOOL *stop) {
    YKEnemyNode *enemy = (YKEnemyNode *)node;
    enemy.position = CGPointMake(enemy.position.x + enemy.velocity.dx * diff, enemy.position.y + enemy.velocity.dy * diff);
    [enemy update:diff];
    
    if (enemy.position.y < -50 || enemy.position.y > CGRectGetMaxY(self.frame) + 50 ||
        enemy.position.x < -50 || enemy.position.x > CGRectGetMaxX(self.frame) + 50) {
      [enemy removeFromParent];
    }
  }];
  
  if (event.powerUp) {
    CGFloat x = ((double)arc4random() / ARC4RANDOM_MAX) * (self.frame.size.width - 20) + 10;
    event.powerUp.powerUp.position = CGPointMake(x, event.powerUp.birthPlace.y + CGRectGetMaxY(self.frame));
    [self addChild:event.powerUp.powerUp];
  }
  
  [self enumerateChildNodesWithName:YKPowerUpName usingBlock:^(SKNode *node, BOOL *stop) {
    YKPowerUp *powerUp = (YKPowerUp *)node;
    CGFloat powerUpVelocity = 80.0 * diff;
    powerUp.position = CGPointMake(powerUp.position.x, powerUp.position.y - powerUpVelocity);
    [powerUp update:diff];
    
    CGFloat distanceToHammy = CPCGPointDistance(powerUp.position, _rocket.position);
    if (distanceToHammy < powerUp.hitRadius + _rocket.hitRadius) {
      [self.rocket applyPowerUp:powerUp];
      [powerUp removeFromParent];
    }
    
    if (powerUp.timeToExist <= 0.0) {
      [powerUp removeFromParent];
    }
  }];
  
  _lastUpdateTime = currentTime;
}

#pragma mark UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  if ([touches count] == 3) {
    self.view.paused = YES;
  }
  else {
    self.view.paused = NO;
    _touched = YES;
    _canFire = YES;
    UITouch *touch = [touches anyObject];
    _lastTouch = [touch locationInNode:self];
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  _lastTouch = [touch locationInNode:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  _touched = NO;
}

@end
