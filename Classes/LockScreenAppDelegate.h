//
//  LockScreenAppDelegate.h
//  LockScreen
//
//  Created by Krishna Kotecha on 07/11/2010.
//  Copyright 2010 Logic Colony Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCYLockScreenViewController.h"

@interface LockScreenAppDelegate : NSObject <UIApplicationDelegate, LCYLockScreenDelegate> 
{    
    UIWindow *window;
    UINavigationController *navigationController;
	
	LCYLockScreenViewController *lockScreenVC_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) IBOutlet LCYLockScreenViewController *lockScreenVC;

- (void) lockScreen: (LCYLockScreenViewController *) lockScreen unlockedApp: (BOOL) unlocked;

@end


@interface LockScreenAppDelegate (AppLock)
- (BOOL) isAppLocked;
- (void) lockApplication;
@end

