//
//  Created by Krishna Kotecha on 23/11/2010.
//  Copyright 2010 Logic Colony Ltd. All rights reserved.
//

#import "LCYTurnOffPasscodeStateMachine.h"


NSString* NSStringFromLCYTurnOffPasscodeStates (LCYTurnOffPasscodeStates state)
{
	NSString *result = nil;
	switch (state) 
	{
		case LCYTurnOffPasscodeStatesConfirmExistingPassword:
			result = @"confirmExistingPassword";
			break;
		case LCYTurnOffPasscodeStatesDone:
			result = @"done";
			break;
		default:
			result = @"Unknown state";
			break;
	}
	return result;
}

@implementation LCYTurnOffPasscodeStateMachine

@synthesize existingPasscode = existingPasscode_;
@synthesize currentErrorText = currentErrorText_;

- (void) dealloc;
{
	self.existingPasscode = nil;
	currentErrorText_ = nil;
	
	[super dealloc];
}

- (id) init;
{
	if ( (self = [super init]) )
	{
		state_ = LCYTurnOffPasscodeStatesConfirmExistingPassword;
	}
	return self;
}


- (NSString *) description;
{
	return [NSString stringWithFormat:@"state: %@ | existingPasscode: %@", 
			NSStringFromLCYTurnOffPasscodeStates(state_),
			self.existingPasscode
			];
}

- (void) successTransition;
{
	currentErrorText_ = nil;
	switch (state_) 
	{
		case LCYTurnOffPasscodeStatesConfirmExistingPassword:
			state_ = LCYTurnOffPasscodeStatesDone;
			break;
		case LCYTurnOffPasscodeStatesDone:
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
		case LCYTurnOffPasscodeStatesConfirmExistingPassword:
			currentErrorText_ = @"Incorrect passcode. Try again.";
			break;
		case LCYTurnOffPasscodeStatesDone:
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
		case LCYTurnOffPasscodeStatesConfirmExistingPassword:
			if ([self.existingPasscode isEqualToString:input])
			{
				[self successTransition];
			}
			else 
			{
				[self failTransition];
			}
			break;
						
		case LCYTurnOffPasscodeStatesDone:
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
		case LCYTurnOffPasscodeStatesConfirmExistingPassword:
			result = @"Enter existing passcode";
			break;
		default:
			result = @"Unknown state";
			break;
	}
	return result;
}

- (BOOL) gotCompletionState;
{
	return (state_ == LCYTurnOffPasscodeStatesDone);
}

- (NSString *) newPasscode;
{
	return nil;
}

- (void) setNewPasscode: (NSString *) nu;
{
}

@end
