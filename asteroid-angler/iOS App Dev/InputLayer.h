//
//  InputLayer.h
//  iOS App Dev
//
//  Created by Loli on 26.09.2013
//  Copyright(c) Loli(r) 2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol InputLayerDelegate <NSObject>

- (void)touchEndedAtPositon:(CGPoint)point afterDelay:(NSTimeInterval)delay;

@end

@interface InputLayer : CCLayer
{
    NSDate *_touchBeganDate;
}

@property (nonatomic, weak) id<InputLayerDelegate> delegate;

@end
