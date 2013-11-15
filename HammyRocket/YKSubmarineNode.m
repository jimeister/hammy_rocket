//
//  YKSubmarineNode.m
//  HammyRocket
//
//  Created by Allen Cheung on 11/15/13.
//  Copyright (c) 2013 HammyRocket. All rights reserved.
//

#import "YKSubmarineNode.h"
#import "UIImage+YKUtils.h"
#import "CPExplosionEmitterNode.h"
#import "CPSmokeEmitterNode.h"
#import "CPMath.h"

static const CGFloat kEmergeDuration = 0.2;
static const CGFloat kDieDuration = 0.5;

@interface YKSubmarineNode ()

@property (strong, nonatomic) SKSpriteNode *bodyNode;
@property (strong, nonatomic) CPSmokeEmitterNode *smokeEmitter;
@property (strong, nonatomic) CPSmokeEmitterNode *fireEmitter;
@property (strong, nonatomic) NSArray *images;

@end

@implementation YKSubmarineNode {
  CGFloat _firingAngle;
  BOOL _damaged;
  
  CGFloat _coolDown;
  CGFloat _fireTimer;
  BOOL _firing;
}

@synthesize bodyNode=_bodyNode;

- (instancetype)init {
  return [self initWithSubmergeTime:8];
}

- (instancetype)initWithSubmergeTime:(CGFloat)submergeTime {
  if ((self = [super init])) {
    _images = [[self class] submarineImages];
    _bodyNode = self.bodyNode;
    
    self.times = @[@(0.01), @(submergeTime)];
    self.events = @[@"emerge", @"submerge"];
    self.health = 30;
    self.ammoSpeed = 150;
    self.score = 5000;
    
    _coolDown = 0.5;
    _fireTimer = 0.5;
    
    self.zPosition = -102;
  }
  return self;
}

- (SKSpriteNode *)bodyNode {
  if (!_bodyNode) {
    _bodyNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:_images[0]]];
    _bodyNode.size = CGSizeMake(32*2.8, 98*2.8);
    [self addChild:_bodyNode];
  }
  return _bodyNode;
}

- (CGRect)frame {
  return CGRectMake(self.position.x - self.bodyNode.size.width/2, self.position.y - self.bodyNode.size.height/2,
                    self.bodyNode.size.width, self.bodyNode.size.height);
}

- (void)emerge {
  SKAction *sequence = [SKAction sequence:@[
                                            [SKAction waitForDuration:kEmergeDuration],
                                            [SKAction setTexture:[SKTexture textureWithImage:self.images[1]]],
                                            [SKAction waitForDuration:kEmergeDuration],
                                            [SKAction setTexture:[SKTexture textureWithImage:self.images[2]]],
                                            [SKAction waitForDuration:kEmergeDuration],
                                            [SKAction setTexture:[SKTexture textureWithImage:self.images[3]]],
                                            [SKAction waitForDuration:kEmergeDuration],
                                            [SKAction setTexture:[SKTexture textureWithImage:self.images[4]]],
                                            [SKAction waitForDuration:kEmergeDuration],
                                            [SKAction setTexture:[SKTexture textureWithImage:self.images[5]]],
                                            ]];
  [self.bodyNode runAction:sequence completion:^() {
    _fireTimer = _coolDown;
    _firing = YES;
  }];
}

- (void)submerge {
  _firing = NO;
  self.dead = YES; // Hack so it can't die and bullets pass through
  self.smokeEmitter.particleBirthRate = 0;
  SKAction *sequence = [SKAction sequence:@[
                                            [SKAction setTexture:[SKTexture textureWithImage:self.images[5]]],
                                            [SKAction waitForDuration:kEmergeDuration],
                                            [SKAction setTexture:[SKTexture textureWithImage:self.images[4]]],
                                            [SKAction waitForDuration:kEmergeDuration],
                                            [SKAction setTexture:[SKTexture textureWithImage:self.images[3]]],
                                            [SKAction waitForDuration:kEmergeDuration],
                                            [SKAction setTexture:[SKTexture textureWithImage:self.images[2]]],
                                            [SKAction waitForDuration:kEmergeDuration],
                                            [SKAction setTexture:[SKTexture textureWithImage:self.images[1]]],
                                            [SKAction waitForDuration:kEmergeDuration],
                                            [SKAction removeFromParent],
                                            [SKAction waitForDuration:0.5],
                                            ]];
  [self.bodyNode runAction:sequence completion:^() {
    [self removeFromParent];
  }];
}

- (void)fireSpread {
  CGFloat angle = _firingAngle;
  for (NSInteger i = 0; i < 8; ++i) {
    YKEnemyAmmo *ammo = [[YKEnemyAmmo alloc] init];
    ammo.velocity = CGVectorMake(150 * CP_SIN(CPDegreesToRadian(angle)), 150 * CP_COS(CPDegreesToRadian(angle)));
    angle += 360 / 8;
    ammo.position = self.position;
    ammo.zPosition = self.zPosition + 1;
    [self.scene addChild:ammo];
  }
  _firingAngle += 22.5;
  _firingAngle = (NSInteger)_firingAngle % 360;
}

+ (NSArray *)submarineImages {
  static NSMutableArray *submarineImages = nil;
  if (!submarineImages) {
    submarineImages = [[NSMutableArray alloc] initWithCapacity:6];
    UIImage *template = [UIImage imageNamed:@"submarine.png"];
    for (NSInteger i = 5; i >= 0; --i) {
      UIImage *sprite = [template yk_imageByCroppingWithRect:CGRectMake(33*i, 0, 32, 98)];
      [submarineImages addObject:sprite];
    }
  }
  return submarineImages;
}

- (void)setHealth:(NSInteger)health {
  [super setHealth:health];
  if (health <= 20 && !_damaged) {
    _damaged = YES;
    CPExplosionEmitterNode *explosion = [[CPExplosionEmitterNode alloc] init];
    explosion.zPosition = self.zPosition + 1;
    explosion.emissionAngle = CPDegreesToRadian(70);
    explosion.emissionAngleRange = CPDegreesToRadian(90);
    explosion.particleLifetime = explosion.particleLifetime * 0.7;
    [explosion setCircleTextureDiameter:10];
    explosion.position = CGPointMake(self.position.x + 10, self.position.y - 30);
    [explosion explodeForDuration:0.6];
    [self.scene addChild:explosion];
    
    CPSmokeEmitterNode *smokeEmitter = [[CPSmokeEmitterNode alloc] init];
    [smokeEmitter advanceSimulationTime:2.0];
    smokeEmitter.particleBirthRate = smokeEmitter.particleBirthRate * 2;
    smokeEmitter.particleLifetime = smokeEmitter.particleLifetime * 0.7;
    smokeEmitter.zPosition = 2;
    smokeEmitter.particleScale = 0.3;
    smokeEmitter.particleSize = CGSizeMake(20, 20);
    smokeEmitter.particleSpeed = 20;
    smokeEmitter.position = CGPointMake(10, -30);
    smokeEmitter.emissionAngle = CPDegreesToRadian(70);
    [self addChild:smokeEmitter];
    self.smokeEmitter = smokeEmitter;
    
    [self runAction:[SKAction playSoundFileNamed:@"explosion.wav" waitForCompletion:NO]];
  }
}

- (void)update:(NSTimeInterval)diff {
  [super update:diff];
  
  if (!self.dead && self.eventIndex < self.times.count && self.timeAlive > [self.times[self.eventIndex] floatValue]) {
    NSString *selectorName = self.events[self.eventIndex];
    [self performSelector:NSSelectorFromString(selectorName)];
    self.eventIndex++;
  }
  
  if (_firing) {
    _fireTimer -= diff;
    if (_fireTimer < 0) {
      _fireTimer = _coolDown;
      [self fireSpread];
    }
  }
}

- (void)die {
  _firing = NO;
  self.smokeEmitter.particleBirthRate = 0;
  
  CPExplosionEmitterNode *explosion = [[CPExplosionEmitterNode alloc] init];
  explosion.zPosition = self.zPosition + 1;
  explosion.emissionAngle = CPDegreesToRadian(110);
  explosion.emissionAngleRange = CPDegreesToRadian(180);
  [explosion setCircleTextureDiameter:15];
  explosion.position = CGPointMake(self.position.x - 10, self.position.y + 20);
  [explosion explodeForDuration:0.6];
  [self.scene addChild:explosion];
  
  double delayInSeconds = kDieDuration;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    CPExplosionEmitterNode *explosion = [[CPExplosionEmitterNode alloc] init];
    explosion.zPosition = self.zPosition + 1;
    explosion.emissionAngle = CPDegreesToRadian(0);
    explosion.emissionAngleRange = CPDegreesToRadian(180);
    [explosion setCircleTextureDiameter:20];
    explosion.position = CGPointMake(self.position.x + 10, self.position.y -30);
    [explosion explodeForDuration:0.6];
    [self.scene addChild:explosion];
  });
  
  delayInSeconds = kDieDuration;
  popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    CPExplosionEmitterNode *explosion = [[CPExplosionEmitterNode alloc] init];
    explosion.zPosition = self.zPosition + 1;
    [explosion setCircleTextureDiameter:20];
    explosion.position = self.position;
    [explosion explodeForDuration:0.8];
    [self.scene addChild:explosion];
  });
  
  SKAction *sequence = [SKAction sequence:@[
                                            [SKAction playSoundFileNamed:@"explosion.wav" waitForCompletion:NO],
                                            [SKAction waitForDuration:kDieDuration],
                                            [SKAction setTexture:[SKTexture textureWithImage:self.images[5]]],
                                            [SKAction playSoundFileNamed:@"explosion.wav" waitForCompletion:NO],
                                            [SKAction waitForDuration:kDieDuration],
                                            [SKAction setTexture:[SKTexture textureWithImage:self.images[4]]],
                                            [SKAction playSoundFileNamed:@"explosion.wav" waitForCompletion:NO],
                                            [SKAction waitForDuration:kDieDuration],
                                            [SKAction setTexture:[SKTexture textureWithImage:self.images[3]]],
                                            [SKAction waitForDuration:kDieDuration],
                                            [SKAction setTexture:[SKTexture textureWithImage:self.images[2]]],
                                            [SKAction waitForDuration:kDieDuration],
                                            [SKAction setTexture:[SKTexture textureWithImage:self.images[1]]],
                                            [SKAction waitForDuration:kDieDuration],
                                            [SKAction removeFromParent],
                                            [SKAction waitForDuration:0.5],
                                            ]];
  [self.bodyNode runAction:sequence completion:^() {
    [self removeFromParent];
  }];
}

@end
