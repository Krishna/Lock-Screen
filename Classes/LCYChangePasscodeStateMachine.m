//
//  StateMachine.m
//  StateMachine
//
//  Created by Krishna Kotecha on 23/11/2010.
//  Copyright 2010 Logic Colony Ltd. All rights reserved.
//

#import "LCYChangePasscodeStateMachine.h"


NSString* NSStringFromState (LCYChangePasscodeStates state)
{
	NSString *result = nil;
	switch (state) 
	{
		case confirmExistingPassword:
			result = @"confirmExistingPassword";
			break;
		case getNewPassword:
			result = @"getNewPassword";
			break;
		case confirmNewPassword:
			result = @"confirmNewPassword";
			break;
		case done:
			result = @"done";
			break;
		default:
			result = @"Unknown state";
			break;
	}
	return result;
}

@implementation LCYChangePasscodeStateMachine

@synthesize newPasscode = newPasscode_;
@synthesize confirmNewPasscode = confirmNewPasscode_;
@synthesize existingPasscode = existingPasscode_;
@synthesize currentErrorText = currentErrorText_;

- (void) dealloc;
{
	self.existingPasscode = nil;
	self.newPasscode = nil;
	self.confirmNewPasscode = nil;
	currentErrorText_ = nil;
	
	[super dealloc];
}

- (id) init;
{
	if ( (self = [super init]) )
	{
		state_ = confirmExistingPassword;
	}
	return self;
}


- (NSString *) description;
{
	return [NSString stringWithFormat:@"state: %@ | existingPasscode: %@ | new: %@ | confirm: %@", 
			NSStringFromState(state_),
			self.existingPasscode,
			self.newPasscode,
			self.confirmNewPasscode
			];
}

- (void) successTransition;
{
	currentErrorText_ = nil;
	switch (state_) 
	{
		case confirmExistingPassword:
			state_ = getNewPassword;
			break;
		case getNewPassword:
			state_ = confirmNewPassword;
			break;
		case confirmNewPassword:
			state_ = done;
			break;
		case done:
			break;
		default:
			NSAssert(NO, @"Unknown state");
			break;
	}	
}

- (void) failTransition;
{
	switch (state_) 
	{
		case confirmExistingPassword:
			currentErrorText_ = @"Incorrect passcode. Try again.";
			break;
		case getNewPassword:
			break;
		case confirmNewPassword:
			self.newPasscode = nil;
			currentErrorText_ = @"Passcode did not match. Try again.";
			state_ = getNewPassword;
			break;
		case done:
			break;
		default:
			NSAssert(NO, @"Unknown state");
			break;
	}
}

- (void) transitionWithInput:(NSString *) input;
{
	switch (state_) 
	{
		case confirmExistingPassword:
			if ([self.existingPasscode isEqualToString:input])
			{
				[self successTransition];
			}
			else 
			{
				[self failTransition];
			}
			break;
			
		case getNewPassword:
			self.newPasscode = input;
			[self successTransition];
			break;
			
		case confirmNewPassword:
			if ([self.newPasscode isEqualToString:input])
			{
				[self successTransition];
			}
			else 
			{
				[self failTransition];
			}

			break;
			
		case done:
			break;
			
		default:
			NSAssert(NO, @"Unknown state");
			break;
	}	
}

- (NSString *) currentPromptText;
{
	NSString *result = nil;
	switch (state_) 
	{
		case confirmExistingPassword:
			result = @"Enter existing passcode";
			break;
		case getNewPassword:
			result = @"Enter new passcode";
			break;
		case confirmNewPassword:
			result = @"Re-enter new passcode";
			break;
		case done:
			result = @"New passcode set";
			break;
		default:
			result = @"Unknown state";
			break;
	}
	return result;
}

- (BOOL) gotCompletionState;
{
	return (state_ == done);
}

@end
