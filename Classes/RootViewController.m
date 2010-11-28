//
//  RootViewController.m
//  LockScreen
//
//  Created by Krishna Kotecha on 07/11/2010.
//  Copyright 2010 Logic Colony Ltd. All rights reserved.
//

#import "RootViewController.h"
#import "LCYLockSettingsViewController.h"
#import "LockScreenAppDelegate.h"

@implementation RootViewController

#pragma mark -
#pragma mark Memory management

- (void) dealloc 
{
    [super dealloc];
}


- (void) didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark View lifecycle

- (void) viewDidLoad  
{
    [super viewDidLoad];
	//	NSString *myfile = [[NSBundle mainBundle] pathForResource:@"Foods" ofType:@"plist"];
	//	[self loadTableDataFromPath:myfile];	

	self.title = @"Main Root";
	
	NSDictionary *dataForTable = [[NSDictionary alloc] initWithObjectsAndKeys:
								  // section titles...
								  @"Comics", @"sectionTitle0",
								  @"Settings", @"sectionTitle1",
								  
								  // data for section 0:
								  [NSArray arrayWithObjects:
								   [NSArray arrayWithObjects:
									@"Batman", 
									@"dummySetting", 
									@"detailDisclosureButton", 
									nil], 
								   [NSArray arrayWithObjects:
									@"Detective Comics", 
									@"dummySetting", 
									@"detailDisclosureButton", 
									nil], 
								   
								   nil], @"0",
								  
								  // data for section 1:
								  [NSArray arrayWithObjects:
								   [NSArray arrayWithObjects:
									@"Lock Screen", 
									@"showLockScreenSettings", 
									@"disclosure", 
									nil], 								   
								   nil], @"1",
								  
								  nil
								  ];
	
	[self setDataUsingDictionary: dataForTable];
	[dataForTable release];
}




#pragma mark -
#pragma mark IBActions

- (IBAction) lockScreen: (id) sender;
{
	LockScreenAppDelegate *appDelegate =  (LockScreenAppDelegate *)	[[UIApplication sharedApplication] delegate];

	NSLog(@"app passcode is: %@", [appDelegate appLockPasscode]);	
	
	if ([appDelegate isAppLocked])
	{		
		[appDelegate lockApplication];
	}
	else 
	{
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Need to set Passcode" message:@"U jelly?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[av show];
		[av release];
	}

}

#pragma mark -
#pragma mark Settings

- (void) dummySetting;
{
	NSLog(@"%s", _cmd);
}

- (void) showLockScreenSettings;
{
	NSLog(@"%s", _cmd);	
	LCYLockSettingsViewController *lockSettingsVC = [[LCYLockSettingsViewController alloc] initWithNibName:@"LCYLockSettingsViewController" bundle:nil];
	[[self navigationController] pushViewController:lockSettingsVC animated:YES];
	[lockSettingsVC release];
	
}

@end

