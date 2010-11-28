//
//  LCYAppSettings.m
//  LockScreen
//
//  Created by Krishna Kotecha on 27/11/2010.
//  Copyright 2010 Logic Colony Ltd. All rights reserved.
//

#import "LCYAppSettings.h"

static NSString * const K_LOCK_SCREEN_PASSCODE_IS_ON = @"lockScreenPasscodeIsOn";
static NSString * const K_LOCK_SCREEN_PASSCODE = @"lockScreenPasscode";

@interface LCYAppSettings()
- (void) updateProperties;
@end

@implementation LCYAppSettings

@synthesize lockScreenPasscodeIsOn = lockScreenPasscodeIsOn_;
@synthesize lockScreenPasscode = lockScreenPasscode_;

- (void) dealloc;
{
	self.lockScreenPasscode = nil;
	[super dealloc];
}

- (id) init;
{
	if ( (self = [super init]) )
	{
		[self updateProperties];
	}
	return self;
}


- (BOOL) synchronize;
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];  
    
    [userDefaults setBool:self.lockScreenPasscodeIsOn forKey:K_LOCK_SCREEN_PASSCODE_IS_ON];

	// as we cant store a nil value in the dictionary, we store an empty string to represent no passcode.
	NSString *passcodeToSave = (self.lockScreenPasscodeIsOn) ? self.lockScreenPasscode : @"" ;
NSLog(@"passcodeToSave: %@", passcodeToSave);
	
	[userDefaults setObject:passcodeToSave forKey:K_LOCK_SCREEN_PASSCODE];
	
	BOOL result = [userDefaults synchronize];
	if (result)
	{
		[self updateProperties];
	}
	return result;
}


- (void) updateProperties;
{
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];	
	self.lockScreenPasscodeIsOn = [userDefaults boolForKey:K_LOCK_SCREEN_PASSCODE_IS_ON];
	lockScreenPasscode_ = [userDefaults stringForKey:K_LOCK_SCREEN_PASSCODE];	
}


@end
