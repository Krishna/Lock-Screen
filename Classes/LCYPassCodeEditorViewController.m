//
//  LCYPassCodeEditorViewController.m
//  LockScreen
//
//  Created by Krishna Kotecha on 22/11/2010.
//   Copyright 2010 Krishna Kotecha. All rights reserved.
//

#import "LCYPassCodeEditorViewController.h"
#import "LCYChangePasscodeStateMachine.h"
#import "LCYTurnOffPasscodeStateMachine.h"
#import "LCYSetPasscodeStateMachine.h"

@interface LCYPassCodeEditorViewController(InputHandling)

- (void) makeCancelButton;

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

@synthesize delegate = delegate_;

@synthesize digitsContainerView = digitsContainerView_;
@synthesize promptLabel = promptLabel_;
@synthesize errorLabel = errorLabel_;

@synthesize passCode = passCode_;

- (void) dealloc 
{
	self.delegate = nil;
		
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
	}
	return self;
}

#pragma mark -
#pragma mark View Lifecycle

- (void) viewDidUnload 
{
    [super viewDidUnload];
	
	self.digitsContainerView = nil;
	self.promptLabel = nil;
	self.errorLabel = nil;
}

- (void) viewWillAppear: (BOOL) animated;
{
	[super viewWillAppear: animated];
//	[self showBanner:self.enterPassCodeBanner];
	self.promptLabel.text = [stateMachine_ currentPromptText];
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
	stateMachine_.existingPasscode = self.passCode;
	
	[self makeCancelButton];
}


- (void) attemptToDisablePassCode;
{
	self.title = @"Turn off Passcode";
	stateMachine_ = turnOffPasscodeStateMachine_;
	[stateMachine_ reset];	
	stateMachine_.existingPasscode = self.passCode;
	
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


- (BOOL) authenticatePassCode: (NSString *) userInput;
{
	BOOL result = NO;
	//NSLog(@"userInput: %@", userInput);
	
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
	[super resetUIState];
	acceptInput_ = YES;
}


- (void) handleCompleteUserInput:(NSString *) userInput;
{
	[stateMachine_ transitionWithInput:userInput];
	//NSLog(@"stateMachine_: %@", stateMachine_);
	
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
}

@end


@implementation LCYPassCodeEditorViewController (UITextFieldDelegate)

- (BOOL) textField: (UITextField *) textField shouldChangeCharactersInRange: (NSRange) range replacementString: (NSString *) string;   // return NO to not change text
{
	if (!acceptInput_)
	{
		return NO;
	}
	
	return [super textField: textField shouldChangeCharactersInRange: range replacementString: string];
	
}

@end
