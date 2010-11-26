//
//  Created by Krishna Kotecha on 23/11/2010.
//  Copyright 2010 Logic Colony Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCYPasscodeUIStateMachine.h"

typedef enum 
{ 
	LCYSetPasscodeStatesGetNewPassword,
	LCYSetPasscodeStatesConfirmNewPassword,
	LCYSetPasscodeStatesDone,
} LCYSetPasscodeStates;

@interface LCYSetPasscodeStateMachine : LCYPasscodeUIStateMachine 
{
	LCYSetPasscodeStates state_;
	NSString *newPasscode_;	
	NSString *currentErrorText_;
}


@property (nonatomic, copy) NSString* newPasscode;

@property (nonatomic, readonly) NSString *currentErrorText;

- (void) transitionWithInput:(NSString *) input;

- (void) successTransition;
- (void) failTransition;

- (NSString *) currentPromptText;

- (BOOL) gotCompletionState;
- (void) reset;

@end
