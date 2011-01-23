//
//  LCYInputDrivenStateMachine.h
//
//  Created by Krishna Kotecha on 25/11/2010.
//  Copyright 2010 Krishna Kotecha. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LCYPasscodeUIStateMachine : NSObject 
{

}

@property (nonatomic, copy) NSString* newPasscode;
@property (nonatomic, copy) NSString* existingPasscode;
@property (nonatomic, readonly) NSString *currentErrorText;

- (NSString *) currentPromptText;

- (void) transitionWithInput:(NSString *) input;
- (BOOL) gotCompletionState;
- (void) reset;


@end
