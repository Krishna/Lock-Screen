//
//  LCYPasscodeInputHandler.m
//  LockScreen
//
//  Created by Krishna Kotecha on 28/11/2010.
//  Copyright 2010 Logic Colony Ltd. All rights reserved.
//

#import "LCYPasscodeInputViewController.h"
#import "LCYLockDigitView.h"

@interface LCYPasscodeInputViewController()

- (void) adjustLockDigitsForDeletePress;
- (void) updateLockDigitsForKeyPress;
- (void) setLockDigit: (int) lockDigitPosition isOn: (BOOL) on;
- (BOOL) haveCompletePassCode;

- (void) handleCompleteUserInput:(NSString *) userInput;
@end



@implementation LCYPasscodeInputViewController

const int PASSCODE_INPUT_HANDLER_PASSCODE_LENGTH = 4;

@synthesize lockDigit_0 = lockDigit_0_;
@synthesize lockDigit_1 = lockDigit_1_;
@synthesize lockDigit_2 = lockDigit_2_;
@synthesize lockDigit_3 = lockDigit_3_;

@synthesize passCodeInputField = passCodeInputField_;

- (void) dealloc 
{
	self.passCodeInputField = nil;

	self.lockDigit_0 = nil;
	self.lockDigit_1 = nil;
	self.lockDigit_2 = nil;
	self.lockDigit_3 = nil;	
			
	[super dealloc];
}

#pragma mark -
#pragma mark View Lifecycle

- (void) viewDidUnload 
{
    [super viewDidUnload];
	
    // Release any retained subviews of the main view.
	self.lockDigit_0 = nil;
	self.lockDigit_1 = nil;
	self.lockDigit_2 = nil;
	self.lockDigit_3 = nil;	
	
	self.passCodeInputField = nil;	
}

- (void) viewWillAppear: (BOOL) animated;
{
	[super viewWillAppear: animated];
	[self.passCodeInputField becomeFirstResponder];	
}


#pragma mark -
#pragma mark LCYLockScreenViewController()



- (void) adjustLockDigitsForDeletePress;
{
	if (self.passCodeInputField.text.length > 0)
	{
		int lockDigitPosition = self.passCodeInputField.text.length - 1;		
		[self setLockDigit: lockDigitPosition isOn: NO];		
	}
}

- (void) updateLockDigitsForKeyPress;
{
	int lockDigitPosition = self.passCodeInputField.text.length;
	[self setLockDigit: lockDigitPosition isOn: YES];
}


- (void) setLockDigit: (int) lockDigitPosition isOn: (BOOL) on;
{	
	switch (lockDigitPosition) 
	{
		case 0:
			self.lockDigit_0.isFilled = on;
			[self.lockDigit_0 setNeedsDisplay];
			break;
			
		case 1:
			self.lockDigit_1.isFilled = on;
			[self.lockDigit_1 setNeedsDisplay];
			break;
			
		case 2:
			self.lockDigit_2.isFilled = on;
			[self.lockDigit_2 setNeedsDisplay];
			break;
			
		case 3:
			self.lockDigit_3.isFilled = on;
			[self.lockDigit_3 setNeedsDisplay];
			break;
			
		default:
			NSAssert(NO, @"Input exceeded number of lock digits");
			break;
	}
	
}

- (BOOL) haveCompletePassCode;
{
	return (self.passCodeInputField.text.length == PASSCODE_INPUT_HANDLER_PASSCODE_LENGTH - 1);
}


- (void) resetUIState;
{
	self.passCodeInputField.text = @"";
	[self setLockDigit: 0 isOn: NO];
	[self setLockDigit: 1 isOn: NO];
	[self setLockDigit: 2 isOn: NO];
	[self setLockDigit: 3 isOn: NO];
}


- (void) handleCompleteUserInput:(NSString *) userInput;
{
		// client dependent stuff...
}


- (BOOL) textField: (UITextField *) textField shouldChangeCharactersInRange: (NSRange) range replacementString: (NSString *) string;   // return NO to not change text
{	
	BOOL acceptInputChanges = YES;
	
	if (range.length == 1 && [string length] == 0)
	{
		//NSLog(@"got a delete press");
		[self adjustLockDigitsForDeletePress];
	}
	else 
	{
		[self updateLockDigitsForKeyPress];
		if ([self haveCompletePassCode])
		{
			NSString *completeUserInput = [NSString stringWithFormat:@"%@%@", self.passCodeInputField.text, string]; 
			[self performSelector:@selector(handleCompleteUserInput:) withObject:completeUserInput afterDelay:0.1];
		}
	}
	
	return acceptInputChanges;
}

@end
