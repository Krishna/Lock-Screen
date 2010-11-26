//
//  StateMachine.m
//  StateMachine
//
//  Created by Krishna Kotecha on 23/11/2010.
//  Copyright 2010 Logic Colony Ltd. All rights reserved.
//

#import "LCYChangePasscodeStateMachine.h"


NSString* NSStringFromLCYChangePasscodeStates (LCYChangePasscodeStates state)
{
	NSString *result = nil;
	switch (state) 
	{
		case LCYChangePasscodeStatesConfirmExistingPassword:
			result = @"confirmExistingPassword";
			break;
		case LCYChangePasscodeStatesGetNewPassword:
			result = @"getNewPassword";
			break;
		case LCYChangePasscodeStatesConfirmNewPassword:
			result = @"confirmNewPassword";
			break;
		case LCYChangePasscodeStatesDone:
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
@synthesize existingPasscode = existingPasscode_;
@synthesize currentErrorText = currentErrorText_;

- (void) dealloc;
{
	self.existingPasscode = nil;
	self.newPasscode = nil;
	currentErrorText_ = nil;
	
	[super dealloc];
}

- (id) init;
{
	if ( (self = [super init]) )
	{
		state_ = LCYChangePasscodeStatesConfirmExistingPassword;
	}
	return self;
}


- (NSString *) description;
{
	return [NSString stringWithFormat:@"state: %@ | existingPasscode: %@ | new: %@", 
			NSStringFromLCYChangePasscodeStates(state_),
			self.existingPasscode,
			self.newPasscode
			];
}

- (void) successTransition;
{
	currentErrorText_ = nil;
	switch (state_) 
	{
		case LCYChangePasscodeStatesConfirmExistingPassword:
			state_ = LCYChangePasscodeStatesGetNewPassword;
			break;
		case LCYChangePasscodeStatesGetNewPassword:
			state_ = LCYChangePasscodeStatesConfirmNewPassword;
			break;
		case LCYChangePasscodeStatesConfirmNewPassword:
			state_ = LCYChangePasscodeStatesDone;
			break;
		case LCYChangePasscodeStatesDone:
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
		case LCYChangePasscodeStatesConfirmExistingPassword:
			currentErrorText_ = @"Incorrect passcode. Try again.";
			break;
		case LCYChangePasscodeStatesGetNewPassword:
			break;
		case LCYChangePasscodeStatesConfirmNewPassword:
			self.newPasscode = nil;
			currentErrorText_ = @"Passcode did not match. Try again.";
			state_ = LCYChangePasscodeStatesGetNewPassword;
			break;
		case LCYChangePasscodeStatesDone:
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
		case LCYChangePasscodeStatesConfirmExistingPassword:
			if ([self.existingPasscode isEqualToString:input])
			{
				[self successTransition];
			}
			else 
			{
				[self failTransition];
			}
			break;
			
		case LCYChangePasscodeStatesGetNewPassword:
			self.newPasscode = input;
			[self successTransition];
			break;
			
		case LCYChangePasscodeStatesConfirmNewPassword:
			if ([self.newPasscode isEqualToString:input])
			{
				[self successTransition];
			}
			else 
			{
				[self failTransition];
			}

			break;
			
		case LCYChangePasscodeStatesDone:
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
		case LCYChangePasscodeStatesConfirmExistingPassword:
			result = @"Enter existing passcode";
			break;
		case LCYChangePasscodeStatesGetNewPassword:
			result = @"Enter new passcode";
			break;
		case LCYChangePasscodeStatesConfirmNewPassword:
			result = @"Re-enter new passcode";
			break;
		case LCYChangePasscodeStatesDone:
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
	return (state_ == LCYChangePasscodeStatesDone);
}

@end
