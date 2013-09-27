//
//  InputLayer.m
//  iOS App Dev
//
//  Created by Loli on 26.09.2013
//  Copyright(c) Loli(r) 2013. All rights reserved.
//

#import "InputLayer.h"


@implementation InputLayer

- (id)init
{
    self = [super init];
    if (self)
    {
        self.touchEnabled = YES;
        self.touchMode = kCCTouchesOneByOne;
    }
    return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    _touchBeganDate = [NSDate date];
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint position = [self convertTouchToNodeSpace:touch];
    NSTimeInterval timeSinceTouchBegan = [_touchBeganDate timeIntervalSinceNow];
    [_delegate touchEndedAtPositon:position afterDelay:-timeSinceTouchBegan];
}

@end
