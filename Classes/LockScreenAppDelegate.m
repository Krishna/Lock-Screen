//
//  LockScreenAppDelegate.m
//  LockScreen
//
//  Created by Krishna Kotecha on 07/11/2010.
//  Copyright 2010 Logic Colony Ltd. All rights reserved.
//

#import "LockScreenAppDelegate.h"
#import "RootViewController.h"
#import "LCYLockScreenViewController.h"

@implementation LockScreenAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize lockScreenVC = lockScreenVC_;


#pragma mark -
#pragma mark Memory management

- (void) dealloc 
{
	self.lockScreenVC = nil;
	[navigationController release];
	[window release];
	[super dealloc];
}

- (void) applicationDidReceiveMemoryWarning: (UIApplication *) application 
{
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}



#pragma mark -
#pragma mark Application lifecycle

- (BOOL) application: (UIApplication *) application didFinishLaunchingWithOptions: (NSDictionary *) launchOptions 
{        
    // Override point for customization after application launch.
    
    // Add the navigation controller's view to the window and display.
    [self.window addSubview:navigationController.view];
	
	if ( [self isAppLocked] )
	{
		lockScreenVC_ = [[LCYLockScreenViewController alloc] initWithNibName:@"LCYLockScreen" bundle:nil];
		self.lockScreenVC.delegate = self;
		[self.window addSubview:self.lockScreenVC.view];
	}
	
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark LockScreenAppDelegate implementation

- (void) lockScreen: (LCYLockScreenViewController *) lockScreen unlockedApp: (BOOL) unlocked;
{
	if (unlocked)
	{
		[lockScreenVC_.view removeFromSuperview];
		self.lockScreenVC = nil;
	}
}

@end


@implementation LockScreenAppDelegate (AppLock)

- (BOOL) isAppLocked;
{
	// TODO: should look in app settings file to determine if the app was locked
	return YES;
}

@end
