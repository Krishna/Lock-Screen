//
//  StateMachine.h
//  StateMachine
//
//  Created by Krishna Kotecha on 23/11/2010.
//  Copyright 2010 Logic Colony Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum 
{ 
	confirmExistingPassword,
	getNewPassword,
	confirmNewPassword,
	done,
} LCYChangePasscodeStates;

@interface LCYChangePasscodeStateMachine : NSObject 
{
	LCYChangePasscodeStates state_;

	NSString *existingPasscode_;
	NSString *newPasscode_;
	NSString *confirmNewPasscode_;	
	
	NSString *currentErrorText_;
}


@property (nonatomic, copy) NSString* existingPasscode;
@property (nonatomic, copy) NSString* newPasscode;
@property (nonatomic, copy) NSString* confirmNewPasscode;

@property (nonatomic, readonly) NSString *currentErrorText;

- (void) transitionWithInput:(NSString *) input;

- (void) successTransition;
- (void) failTransition;

- (NSString *) currentPromptText;

- (BOOL) gotCompletionState;


@end
