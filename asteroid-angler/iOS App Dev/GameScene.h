//
//  Game.h
//  iOS App Dev
//
//  Created by Loli on 26.09.2013
//  Copyright(c) Loli(r) 2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "InputLayer.h"

@class Angler;
@class Enemy;
@interface GameScene : CCScene <InputLayerDelegate>
{
    CGSize _winSize;
    NSDictionary *_configuration;
//    CCLayerGradient *_skyLayer;
    CCSprite *_spaceLayer;
//    CCSprite *_spaceLayer;         //double check
//    CCSprite *deepSpace;           //double check
    CGFloat _windSpeed;
    Angler *_angler;
    Enemy *_enemy;
    ChipmunkSpace *_space;
    ccTime _accumulator;
    CCParallaxNode *_parallaxNode;
    CCParticleSystemQuad *_splashParticles;
    CCNode *_gameNode;
    BOOL _followTank;
    CGFloat _landscapeWidth;
}

@end
