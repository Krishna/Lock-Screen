//
//  LCYInputDrivenStateMachine.m
//  LockScreen
//
//  Created by Krishna Kotecha on 25/11/2010.
//  Copyright 2010 Logic Colony Ltd. All rights reserved.
//

#import "LCYPasscodeUIStateMachine.h"


@implementation LCYPasscodeUIStateMachine

@dynamic newPasscode;
@dynamic existingPasscode;
@dynamic currentErrorText;

- (NSString *) currentPromptText;
{
	return nil;
}

- (void) transitionWithInput:(NSString *) input;
{
}

- (BOOL) gotCompletionState;
{
	return NO;
}

@end
