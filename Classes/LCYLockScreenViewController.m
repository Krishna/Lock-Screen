//
//  LCYLockScreen.m
//  LockScreen
//
//  Created by Krishna Kotecha on 07/11/2010.
//  Copyright 2010 Logic Colony Ltd. All rights reserved.
//

#import "LCYLockScreenViewController.h"

@interface LCYLockScreenViewController (UITextFieldDelegate)
- (BOOL) textField: (UITextField *) textField shouldChangeCharactersInRange: (NSRange) range replacementString: (NSString *) string;   // return NO to not change text
@end

@interface LCYLockScreenViewController()
- (void) adjustLockDigitsForDeletePress;
- (void) updateLockDigitsForKeyPress;
- (void) setLockDigit: (int) lockDigit isOn: (BOOL) on;
- (BOOL) haveCompletePassCode;
- (BOOL) authenticatePassCode: (NSString *) userInput;
- (void) resetUIState;

- (void) handleCompleteUserInput:(NSString *) userInput;

- (void) showBanner: (UIView *) bannerView;
- (void) hideBanner: (UIView *) bannerView;
- (BOOL) isShowingBanner: (UIView *) bannerView;

- (NSString *) passCode;
@end


@implementation LCYLockScreenViewController

const int PASSCODE_LENGTH = 4;

@synthesize lockDigit_0 = lockDigit_0_;
@synthesize lockDigit_1 = lockDigit_1_;
@synthesize lockDigit_2 = lockDigit_2_;
@synthesize lockDigit_3 = lockDigit_3_;

@synthesize passCodeInputField = passCodeInputField_;

@synthesize enterPassCodeBanner = enterPassCodeBanner_;
@synthesize wrongPassCodeBanner = wrongPassCodeBanner_;

@synthesize delegate = delegate_;
@synthesize passCode = passCode_;

#pragma mark -
#pragma mark Memory Management

- (void) dealloc 
{
	self.passCodeInputField = nil;
	self.lockDigit_0 = nil;
	self.lockDigit_1 = nil;	
	self.lockDigit_2 = nil;
	self.lockDigit_3 = nil;
	self.enterPassCodeBanner = nil;
	self.wrongPassCodeBanner = nil;
	self.delegate = nil;
	
    [super dealloc];
}

- (void) didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
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
	
	self.enterPassCodeBanner = nil;
	self.wrongPassCodeBanner = nil;	
}

- (void) viewWillAppear: (BOOL) animated;
{
	[super viewWillAppear: animated];
	[self showBanner:self.enterPassCodeBanner];
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
	return (self.passCodeInputField.text.length == PASSCODE_LENGTH - 1);
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
		[self.enterPassCodeBanner removeFromSuperview];		
		[self showBanner:self.wrongPassCodeBanner];
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
}


- (void) handleCompleteUserInput:(NSString *) userInput;
{
	if ( [self authenticatePassCode: userInput] )	
	{
		[self.delegate lockScreen:self unlockedApp:YES];
	}	
}


- (void) showBanner: (UIView *) bannerView;
{	
	if ( ![self isShowingBanner:bannerView] )
	{
		// TODO: we should only do the statusBar check if we are running on an iPhone.
		//		 On the iPad we should display the lock screen in a window.
		
		UIApplication *app = [UIApplication sharedApplication];	
		if (!app.statusBarHidden)
		{	
			bannerView.frame = CGRectOffset(bannerView.frame, 0, [app statusBarFrame].size.height);
		}
		
		[self.view addSubview:bannerView];
	}
}

- (void) hideBanner: (UIView *) bannerView;
{
	if ( [self isShowingBanner:bannerView] )
	{
		[bannerView removeFromSuperview];
	}
}

- (BOOL) isShowingBanner: (UIView *) bannerView;
{
	return (bannerView.superview == self.view);
}

@end


@implementation LCYLockScreenViewController (UITextFieldDelegate)

- (BOOL) textField: (UITextField *) textField shouldChangeCharactersInRange: (NSRange) range replacementString: (NSString *) string;   // return NO to not change text
{
//	NSLog(@"%s - range: %@ | replacementString: %@ | textfield length: %d", _cmd, NSStringFromRange(range), string, self.passCodeInputField.text.length);
	
	// passCodeInputField.text.length is the length BEFORE we add the character the user just enetered.
	
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


