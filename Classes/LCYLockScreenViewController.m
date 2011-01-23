//
//  LCYLockScreen.m
//  LockScreen
//
//  Created by Krishna Kotecha on 07/11/2010.
//   Copyright 2010 Krishna Kotecha. All rights reserved.
//

#import "LCYLockScreenViewController.h"

@interface LCYLockScreenViewController (UITextFieldDelegate)
- (BOOL) textField: (UITextField *) textField shouldChangeCharactersInRange: (NSRange) range replacementString: (NSString *) string;   // return NO to not change text
@end

@interface LCYLockScreenViewController()
- (BOOL) authenticatePassCode: (NSString *) userInput;
- (void) handleCompleteUserInput:(NSString *) userInput;

- (void) showBanner: (UIView *) bannerView;
- (void) hideBanner: (UIView *) bannerView;
- (BOOL) isShowingBanner: (UIView *) bannerView;

- (NSString *) passCode;
@end


@implementation LCYLockScreenViewController

@synthesize enterPassCodeBanner = enterPassCodeBanner_;
@synthesize wrongPassCodeBanner = wrongPassCodeBanner_;

@synthesize delegate = delegate_;
@synthesize passCode = passCode_;

#pragma mark -
#pragma mark Memory Management

- (void) dealloc 
{
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
	
	self.enterPassCodeBanner = nil;
	self.wrongPassCodeBanner = nil;	
}

- (void) viewWillAppear: (BOOL) animated;
{
	[super viewWillAppear: animated];
	[self showBanner:self.enterPassCodeBanner];
	
	// iOS 3.0 compatibility: change the background colour to one that is available on earlier versions of the OS...
	if (![UIColor respondsToSelector:@selector(scrollViewTexturedBackgroundColor)])
	{
		self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	}
}


#pragma mark -
#pragma mark LCYLockScreenViewController()

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
		[self.enterPassCodeBanner removeFromSuperview];		
		[self showBanner:self.wrongPassCodeBanner];
		[self resetUIState];
	}
	
	return result;

	
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


