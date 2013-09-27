//
//  Tank.m
//  iOS App Dev
//
//  Created by Loli on 26.09.2013
//  Copyright(c) Loli(r) 2013. All rights reserved.
//

#import "Angler.h"


@implementation Angler

- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position;
{
    self = [super initWithFile:@"angler.png"];
    if (self)
    {
        _space = space;
        
        if (_space != nil)
        {
            CGSize size = self.textureRect.size;
            cpFloat mass = size.width * size.height;
            cpFloat moment = cpMomentForBox(mass, size.width, size.height);
            
            ChipmunkBody *body = [ChipmunkBody bodyWithMass:mass andMoment:moment];
            body.pos = position;
            ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:body width:size.width/3 height:size.height/2];
            
            // Add to space
            [_space addBody:body];
            [_space addShape:shape];
            
            // Add to pysics sprite
            self.chipmunkBody = body;
        }
    }
    return self;
}

-(void)thrust
{
    cpVect impulseVector = cpvmult(cpv(1.0,0.0), self.chipmunkBody.mass * 150);
    [self.chipmunkBody applyImpulse:impulseVector offset:cpvzero];
}

- (void)jumpWithPower:(CGFloat)power vector:(cpVect)vector
{
    cpVect impulseVector = cpvmult(vector, self.chipmunkBody.mass * power);
    [self.chipmunkBody applyImpulse:impulseVector offset:cpvzero];
}
- (void)jump
{
    //cpVect normalizedVector = cpvnormalize(cpvsub(100, 100));
    cpVect impulseVector = cpvmult(cpv(0.0,2.0), self.chipmunkBody.mass * 15);
    [self.chipmunkBody applyImpulse:impulseVector offset:cpvzero];
}

@end
