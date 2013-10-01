//
//  AppDelegate.h
//  Tank
//
//  Created by Loli on 26.09.2013
//  Copyright(c) Loli(r) 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

// Added only for iOS 6 support
@interface NavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate>
{
    UIWindow *_window;
    NavigationController *_navController;
    CCDirectorIOS *_director;
}


@end
