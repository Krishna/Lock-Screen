//
//  LCYPassCodeEditorViewController.m
//  LockScreen
//
//  Created by Krishna Kotecha on 22/11/2010.
//  Copyright 2010 Logic Colony Ltd. All rights reserved.
//

#import "LCYPassCodeEditorViewController.h"
#import "LCYChangePasscodeStateMachine.h"
#import "LCYTurnOffPasscodeStateMachine.h"
#import "LCYSetPasscodeStateMachine.h"

@interface LCYPassCodeEditorViewController(InputHandling)

- (void) makeCancelButton;

- (void) adjustLockDigitsForDeletePress;
- (void) updateLockDigitsForKeyPress;
- (void) setLockDigit: (int) lockDigitPosition isOn: (BOOL) on;
- (BOOL) haveCompletePassCode;
- (BOOL) authenticatePassCode: (NSString *) userInput;
- (void) resetUIState;

- (void) handleCompleteUserInput:(NSString *) userInput;
- (void) scrollLockDigitsOffLeftSideOfScreenAndSetPromptTo: (NSString *) newPrompt errorText: (NSString *) errorText;
- (void) moveLockDigitsToOffscreenRight;
- (void) scrollLockDigitsFromRightOfScreenBackToCenter;
- (void) lockDigitsScrollOffScreenDidStop: (NSString *) animationID finished: (NSNumber *) finished context: (void *) context; 
- (void) lockDigitsScrollBackOnScreenDidStop: (NSString *) animationID finished: (NSNumber *) finished context: (void *) context; 

@end

@implementation LCYPassCodeEditorViewController

const int PASSCODE_EDITOR_PASSCODE_LENGTH = 4;

@synthesize delegate = delegate_;

@synthesize lockDigit_0 = lockDigit_0_;
@synthesize lockDigit_1 = lockDigit_1_;
@synthesize lockDigit_2 = lockDigit_2_;
@synthesize lockDigit_3 = lockDigit_3_;

@synthesize passCodeInputField = passCodeInputField_;

@synthesize digitsContainerView = digitsContainerView_;
@synthesize promptLabel = promptLabel_;
@synthesize errorLabel = errorLabel_;

@synthesize passCode = passCode_;

- (void) dealloc 
{
	self.delegate = nil;
	
	self.passCodeInputField = nil;
	self.lockDigit_0 = nil;
	self.lockDigit_1 = nil;
	self.lockDigit_2 = nil;
	self.lockDigit_3 = nil;	
	
	self.digitsContainerView = nil;
	self.promptLabel = nil;
	self.errorLabel = nil;
	
	[changePasscodeStateMachine_ release];
	changePasscodeStateMachine_ = nil;
	
	[turnOffPasscodeStateMachine_ release];
	turnOffPasscodeStateMachine_ = nil;
	
	[setPasscodeStateMachine_ release];
	setPasscodeStateMachine_ = nil;
	
	//[stateMachine_ release];
	stateMachine_ = nil;
	
	[super dealloc];
}

#pragma mark -
#pragma mark Initialization

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil;
{
	if ( (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) )
	{
		changePasscodeStateMachine_ = [[LCYChangePasscodeStateMachine alloc] init];
		turnOffPasscodeStateMachine_ = [[LCYTurnOffPasscodeStateMachine alloc] init];
		setPasscodeStateMachine_ = [[LCYSetPasscodeStateMachine alloc] init];
//		stateMachine_ = [[LCYChangePasscodeStateMachine alloc] init];
//		stateMachine_.existingPasscode = @"7890";
	}
	return self;
}

#pragma mark -
#pragma mark View Lifecycle

- (void) viewDidUnload 
{
    [super viewDidUnload];

	self.passCodeInputField = nil;
	self.lockDigit_0 = nil;
	self.lockDigit_1 = nil;
	self.lockDigit_2 = nil;
	self.lockDigit_3 = nil;	
	
	self.digitsContainerView = nil;
	self.promptLabel = nil;
	self.errorLabel = nil;
}

- (void) viewWillAppear: (BOOL) animated;
{
	[super viewWillAppear: animated];
//	[self showBanner:self.enterPassCodeBanner];
	self.promptLabel.text = [stateMachine_ currentPromptText];
	[self.passCodeInputField becomeFirstResponder];	
	acceptInput_ = YES;
}

#pragma mark -
#pragma mark Set up code

- (void) makeCancelButton;
{
	UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = cancelButtonItem;
    [cancelButtonItem release];	
}

- (void) attemptToSetANewPassCode;
{
	self.title = @"Set Passcode";
	stateMachine_ = setPasscodeStateMachine_;
	[stateMachine_ reset];	
	[self makeCancelButton];
}

- (void) attemptChangePassCode;
{
	self.title = @"Change Passcode";
	stateMachine_ = changePasscodeStateMachine_;
	[stateMachine_ reset];
	stateMachine_.existingPasscode = @"7890";
	
	[self makeCancelButton];
}


- (void) attemptToDisablePassCode;
{
	self.title = @"Turn off Passcode";
	stateMachine_ = turnOffPasscodeStateMachine_;
	[stateMachine_ reset];	
	stateMachine_.existingPasscode = @"7890";
	
	[self makeCancelButton];	
}

#pragma mark -
#pragma mark IBActions

- (IBAction) cancel;
{
	[delegate_ passcodeEditor:self newCode:nil];
}


#pragma mark -
#pragma mark LCYPassCodeEditorViewController(InputHandling) / copied from LCYLockScreenViewController


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
	UIColor *colorForLockDigit = on ? [UIColor redColor] : [UIColor whiteColor];
	
	switch (lockDigitPosition) 
	{
		case 0:
			self.lockDigit_0.backgroundColor = colorForLockDigit;
			break;
			
		case 1:
			self.lockDigit_1.backgroundColor = colorForLockDigit;			
			break;
			
		case 2:
			self.lockDigit_2.backgroundColor = colorForLockDigit;			
			break;
			
		case 3:
			self.lockDigit_3.backgroundColor = colorForLockDigit;		
			break;
			
		default:
			NSAssert(NO, @"Input exceeded number of lock digits");
			break;
	}
	
}

- (BOOL) haveCompletePassCode;
{
	return (self.passCodeInputField.text.length == PASSCODE_EDITOR_PASSCODE_LENGTH - 1);
}

- (BOOL) authenticatePassCode: (NSString *) userInput;
{
	BOOL result = NO;
	NSLog(@"userInput: %@", userInput);
	
	if ( [userInput isEqualToString:[self passCode]] )
	{
		result = YES;
	}
	else 
	{
//		[self.enterPassCodeBanner removeFromSuperview];		
//		[self showBanner:self.wrongPassCodeBanner];
		[self resetUIState];
	}
	
	return result;
}

- (void) resetUIState;
{
	self.passCodeInputField.text = @"";
	[self setLockDigit: 0 isOn: NO];
	[self setLockDigit: 1 isOn: NO];
	[self setLockDigit: 2 isOn: NO];
	[self setLockDigit: 3 isOn: NO];
	acceptInput_ = YES;
}


- (void) handleCompleteUserInput:(NSString *) userInput;
{
	[stateMachine_ transitionWithInput:userInput];
	NSLog(@"stateMachine_: %@", stateMachine_);
	
	if ([stateMachine_ gotCompletionState])
	{
		[self.delegate passcodeEditor:self newCode:stateMachine_.newPasscode];
	}
	else 
	{
		NSString *promptText = [stateMachine_ currentPromptText];
		NSString *errorText = [stateMachine_ currentErrorText];
		
		//	[self scrollLockDigitsOffLeftSideOfScreenAndSetPromptTo:@"Re-enter your new passcode"];
		[self scrollLockDigitsOffLeftSideOfScreenAndSetPromptTo:promptText errorText:errorText];		
	}

}


/*
- (void) handleCompleteUserInput:(NSString *) userInput;
{
	NSLog(@"%s got: %@", _cmd, userInput);
//	[self resetUIState];
		
	if ( [self authenticatePassCode: userInput] )
	{
		NSLog(@"authenticated ok");		
	}
	
	NSLog(@"digits container frame: %@", NSStringFromCGRect(self.digitsContainerView.frame));
	
	// newPassCode = userInput
	// animate digits going off left of screen
	[self scrollLockDigitsOffLeftSideOfScreenAndSetPromptTo:@"Re-enter your new passcode"];
	
	// change label to: Re-enter your new passcode
}
*/

- (void) scrollLockDigitsOffLeftSideOfScreenAndSetPromptTo: (NSString *) newPrompt errorText: (NSString *) errorText;
{
	acceptInput_ = NO;
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration: 0.25];
	[UIView setAnimationDelegate:self];	
	[UIView setAnimationDidStopSelector:@selector(lockDigitsScrollOffScreenDidStop:finished:context:)];	
	
	CGRect newFrame = CGRectOffset(self.digitsContainerView.frame, 0 - (self.digitsContainerView.frame.size.width + 20), 0);
	self.digitsContainerView.frame	= newFrame;
	
	self.promptLabel.text = newPrompt;
	self.errorLabel.text = errorText;
	
    [UIView commitAnimations];		
}

- (void) moveLockDigitsToOffscreenRight;
{
	CGRect newFrame = self.digitsContainerView.frame;
	newFrame.origin.x = newFrame.size.width + self.view.frame.size.width;
	self.digitsContainerView.frame = newFrame;	
}

- (void) scrollLockDigitsFromRightOfScreenBackToCenter;
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration: 0.25];
	[UIView setAnimationDelegate:self];	
	[UIView setAnimationDidStopSelector:@selector(lockDigitsScrollBackOnScreenDidStop:finished:context:)];	
	
	CGRect newFrame = self.digitsContainerView.frame;
	newFrame.origin.x = 20;	
	self.digitsContainerView.frame	= newFrame;		
    [UIView commitAnimations];		
}

- (void) lockDigitsScrollOffScreenDidStop: (NSString *) animationID finished: (NSNumber *) finished context: (void *) context; 
{
	[self moveLockDigitsToOffscreenRight];
	[self resetUIState];
	[self scrollLockDigitsFromRightOfScreenBackToCenter];
}

- (void) lockDigitsScrollBackOnScreenDidStop: (NSString *) animationID finished: (NSNumber *) finished context: (void *) context; 
{
	acceptInput_ = YES;
	NSLog(@"animation finito");
}

@end


@implementation LCYPassCodeEditorViewController (UITextFieldDelegate)

- (BOOL) textField: (UITextField *) textField shouldChangeCharactersInRange: (NSRange) range replacementString: (NSString *) string;   // return NO to not change text
{
	//	NSLog(@"%s - range: %@ | replacementString: %@ | textfield length: %d", _cmd, NSStringFromRange(range), string, self.passCodeInputField.text.length);
	
	// passCodeInputField.text.length is the length BEFORE we add the character the user just enetered.
	
	if (!acceptInput_)
	{
		return NO;
	}
	
	BOOL acceptInputChanges = YES;
	
	if (range.length == 1 && [string length] == 0)
	{
		NSLog(@"got a delete press");
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
