//
//  Goal.h
//  iOS App Dev
//
//  Created by Loli on 26.09.2013
//  Copyright(c) Loli(r) 2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Enemy : CCPhysicsSprite {
    
}

- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position;

@end
