//
//  Goal.m
//  iOS App Dev
//
//  Created by Loli on 26.09.2013
//  Copyright(c) Loli(r) 2013. All rights reserved.
//

#import "Enemy.h"
#import "ObjectiveChipmunk.h"

@implementation Enemy

- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position
{
    self = [super initWithFile:@"enemy2.png"];
    if (self) {
        CGSize size = self.textureRect.size;
        
        // Create body and shape
        ChipmunkBody *body = [ChipmunkBody staticBody];
        body.pos = position;
        ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:body width:size.width height:size.height/6];
        shape.sensor = YES;
        
        // Add to world
        [space addShape:shape];
        
        // Add self to body and body to self
        body.data = self;
        self.chipmunkBody = body;
    }
    return self;
}

@end
