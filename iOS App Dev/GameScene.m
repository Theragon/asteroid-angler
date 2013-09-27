//
//  Game.m
//  iOS App Dev
//
//  Created by Loli on 26.09.2013
//  Copyright(c) Loli(r) 2013. All rights reserved.
//

#import "GameScene.h"
#import "Angler.h"
#import "InputLayer.h"
#import "ChipmunkAutoGeometry.h"
#import "Enemy.h"
#import "SimpleAudioEngine.h"

@implementation GameScene

#pragma mark - Initilization

- (id)init
{
    self = [super init];
    if (self)
    {
        srandom(time(NULL));
        _winSize = [CCDirector sharedDirector].winSize;
        
        // Load configuration file
        _configuration = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"]];
        
        // Create physics world
        _space = [[ChipmunkSpace alloc] init];
        CGFloat gravity = [_configuration[@"gravity"] floatValue];
        _space.gravity = ccp(0.0f, -gravity);
        
        // Register collision handler
        [_space setDefaultCollisionHandler:self
                                     begin:@selector(collisionBegan:space:)
                                  preSolve:nil
                                 postSolve:nil
                                  separate:nil];
        
        // Setup world
        [self generateRandomWind];
        [self setupGraphicsLandscape];
        [self setupPhysicsLandscape1];
        [self setupPhysicsLandscape2];
        
        // Create debug node
        CCPhysicsDebugNode *debugNode = [CCPhysicsDebugNode debugNodeForChipmunkSpace:_space];
        debugNode.visible = YES;
        [self addChild:debugNode];
        
        // Add a tank
        NSString *tankPositionString = _configuration[@"tankPosition"];
        _angler = [[Angler alloc] initWithSpace:_space position:CGPointFromString(tankPositionString)];
        [_gameNode addChild:_angler];
        
        // Add goal
//        _goal = [[Goal alloc] initWithSpace:_space position:CGPointFromString(_configuration[@"goalPosition"])];
//        [_gameNode addChild:_goal];
        
        // Enemy asteroids
        NSUInteger lowerBound = 60;
        NSUInteger upperBound = 260;
        bool first = YES;
        
        for (NSUInteger i = 1; i < 2048; ++i)
        {
            if(i%256==0)
            {
                if(first == NO)
                {
                    NSUInteger rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
                    //                _enemy = [[Enemy alloc] initWithSpace:_space position:ccp(i, ((CCRANDOM_0_1()*300)+20))];
                    _enemy = [[Enemy alloc] initWithSpace:_space position:ccp(i, rndValue)];
                    [_gameNode addChild:_enemy];
                }
                
                first = NO;
            }
        }
        
        // Create a input layer
        InputLayer *inputLayer = [[InputLayer alloc] init];
        inputLayer.delegate = self;
        [self addChild:inputLayer];
        
        // Setup particle system
        _splashParticles = [CCParticleSystemQuad particleWithFile:@"WaterSplash.plist"];
        _splashParticles.position = _enemy.position;
        [_splashParticles stopSystem];
        [_gameNode addChild:_splashParticles];
        
        // Preload sound effects
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"Impact.wav"];
        
        // Your initilization code goes here
        [self scheduleUpdate];
        _followTank = YES;
        [_angler thrust];
    }
    return self;
}

- (bool)collisionBegan:(cpArbiter *)arbiter space:(ChipmunkSpace*)space {
    cpBody *firstBody;
    cpBody *secondBody;
    cpArbiterGetBodies(arbiter, &firstBody, &secondBody);
    
    ChipmunkBody *firstChipmunkBody = firstBody->data;
    ChipmunkBody *secondChipmunkBody = secondBody->data;
    
    NSLog(@"A collision has occured and the game should end");
    
    if ((firstChipmunkBody == _angler.chipmunkBody && secondChipmunkBody == _enemy.chipmunkBody) ||
        (firstChipmunkBody == _enemy.chipmunkBody && secondChipmunkBody == _angler.chipmunkBody)){
        NSLog(@"TANK HIT GOAL :D:D:D xoxoxo");
        
        // Play sfx
        [[SimpleAudioEngine sharedEngine] playEffect:@"Impact.wav" pitch:(CCRANDOM_0_1() * 0.3f) + 1 pan:0 gain:1];
        
        // Remove physics body
        [_space smartRemove:_angler.chipmunkBody];
        for (ChipmunkShape *shape in _angler.chipmunkBody.shapes) {
            [_space smartRemove:shape];
        }
        
        // Remove tank from cocos2d
        [_angler removeFromParentAndCleanup:YES];
        
        // Play particle effect
        [_splashParticles resetSystem];
    }
    
    return YES;
}

- (void)setupGraphicsLandscape
{
    // Space
    _spaceLayer = [CCSprite spriteWithFile:@"Deep-Space.png"];
    _spaceLayer.anchorPoint=ccp(0,0);
    [self addChild:_spaceLayer z:0];
    
    // Asteroids
    for (NSUInteger i = 0; i < 4; ++i)
    {
        CCSprite *asteroid = [CCSprite spriteWithFile:@"asteroid_mathilde.png"];
        asteroid.position = ccp(CCRANDOM_0_1() * _winSize.width, (CCRANDOM_0_1() * 200) + _winSize.height / 2);
        [_spaceLayer addChild:asteroid z:1 ];
    }

    _parallaxNode = [CCParallaxNode node];
    [self addChild:_parallaxNode z:1];
    
    CCSprite *asteroids1 = [CCSprite spriteWithFile:@"asteroids_1.png"];
    asteroids1.anchorPoint = ccp(0, 0);
    [_parallaxNode addChild:asteroids1 z:0 parallaxRatio:ccp(0.5f, 1.0f) positionOffset:CGPointZero];
    
//    CCSprite *asteroids2 = [CCSprite spriteWithFile:@"asteroids_2.png"];
//    asteroids2.anchorPoint = ccp(0, 0);
//    [_parallaxNode addChild:asteroids2 z:0 parallaxRatio:ccp(0.5f, 1.0f) positionOffset:CGPointZero];
    
    CCSprite *landscapeLower = [CCSprite spriteWithFile:@"AsteroidFieldLower.png"];
    landscapeLower.anchorPoint = ccp(0, 0);
    _landscapeWidth = landscapeLower.contentSize.width;
    [_parallaxNode addChild:landscapeLower z:3 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    
    CCSprite *landscapeUpper = [CCSprite spriteWithFile:@"AsteroidFieldUpper.png"];
    landscapeUpper.anchorPoint = ccp(0, 0);
    _landscapeWidth = landscapeUpper.contentSize.width;
   [_parallaxNode addChild:landscapeUpper z:3 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    
    _gameNode = [CCNode node];
    [_parallaxNode addChild:_gameNode z:3 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
}

- (void)setupPhysicsLandscape1
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"LowerCollisionField" withExtension:@"png"];
    ChipmunkImageSampler *sampler = [ChipmunkImageSampler samplerWithImageFile:url isMask:NO];
    
    ChipmunkPolylineSet *contour = [sampler marchAllWithBorder:NO hard:YES];
    ChipmunkPolyline *line = [contour lineAtIndex:0];
    ChipmunkPolyline *simpleLine = [line simplifyCurves:1];
    
    ChipmunkBody *terrainBody = [ChipmunkBody staticBody];
    NSArray *terrainShapes = [simpleLine asChipmunkSegmentsWithBody:terrainBody radius:0 offset:cpvzero];
    for (ChipmunkShape *shape in terrainShapes)
    {
        [_space addShape:shape];
    }
}

- (void)setupPhysicsLandscape2
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"UpperCollisionField" withExtension:@"png"];
    ChipmunkImageSampler *sampler = [ChipmunkImageSampler samplerWithImageFile:url isMask:NO];
    
    ChipmunkPolylineSet *contour = [sampler marchAllWithBorder:YES hard:YES];
    ChipmunkPolyline *line = [contour lineAtIndex:0];
    ChipmunkPolyline *simpleLine = [line simplifyCurves:1];
    
    ChipmunkBody *terrainBody = [ChipmunkBody staticBody];
    NSArray *terrainShapes = [simpleLine asChipmunkSegmentsWithBody:terrainBody radius:0 offset:cpvzero];
    for (ChipmunkShape *shape in terrainShapes)
    {
        [_space addShape:shape];
    }
}

- (void)generateRandomWind
{
    _windSpeed = CCRANDOM_0_1() * [_configuration[@"windMaxSpeed"] floatValue];
}


#pragma mark - Update

- (void)update:(ccTime)delta
{
    CGFloat fixedTimeStep = 1.0f / 240.0f;
    _accumulator += delta;
    while (_accumulator > fixedTimeStep)
    {
        [_space step:fixedTimeStep];
        _accumulator -= fixedTimeStep;
    }
    
    for (CCSprite *cloud in _spaceLayer.children)
    {
        CGFloat cloudHalfWidth = cloud.contentSize.width / 2;
        CGPoint newPosition = ccp(cloud.position.x + (_windSpeed * delta), cloud.position.y);
        if (newPosition.x < -cloudHalfWidth)
        {
            newPosition.x = _spaceLayer.contentSize.width + cloudHalfWidth;
        }
        else if (newPosition.x > (_spaceLayer.contentSize.width + cloudHalfWidth))
        {
            newPosition.x = -cloudHalfWidth;
        }

        
        cloud.position = newPosition;
    }
    
    if (_angler.position.x >= (_winSize.width / 2) && _angler.position.x < (_landscapeWidth - (_winSize.width / 2)))
    {
        _parallaxNode.position = ccp(-(_angler.position.x - (_winSize.width / 2)), 0);
    }
}

#pragma mark - My Touch Delegate Methods

- (void)touchEndedAtPositon:(CGPoint)position afterDelay:(NSTimeInterval)delay
{

    [_angler jump];
}

@end
