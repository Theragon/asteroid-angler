//
//  Tank.h
//  iOS App Dev
//
//  Created by Loli on 26.09.2013
//  Copyright(c) Loli(r) 2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Angler : CCPhysicsSprite
{
    ChipmunkSpace *_space;
}

- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position;
- (void)jumpWithPower:(CGFloat)power vector:(cpVect)vector;
- (void)jump;
- (void)thrust;

@end
