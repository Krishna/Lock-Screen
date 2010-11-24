//
//  LCYLockSettingsViewController.m
//  LockScreen
//
//  Created by Krishna Kotecha on 22/11/2010.
//  Copyright 2010 Logic Colony Ltd. All rights reserved.
//

#import "LCYLockSettingsViewController.h"

@interface LCYLockSettingsViewController()
- (void) handleTogglePasscode;
- (void) handleChangePasscode;
@end


@implementation LCYLockSettingsViewController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil
{
	if ( (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) )
	{
		sectionTitles_ = [[NSArray alloc] initWithObjects:@"", @"", nil];
		self.title = @"Passcode Lock";
	}
	return self;
}

#pragma mark -
#pragma mark Memory management

- (void) dealloc 
{
	[sectionTitles_ release];
	sectionTitles_ = nil;
    [super dealloc];
}

- (void) didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

#pragma mark -
#pragma mark View lifecycle

- (void) viewDidUnload 
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView 
{
    // Return the number of sections.
    return 2;
}


- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section 
{
	NSInteger result = 0;
	
	switch (section) {
		case 0:
			result = 1;
			break;
		case 1:
			result = 1;
			break;
		default:
			break;
	}
	
    return result;
}

- (void) configureCell: (UITableViewCell *) cell forIndexPath: (NSIndexPath *) indexPath;
{
	NSInteger section = indexPath.section;

	if (section == 0)
	{
		cell.textLabel.text = passCodeLockIsOn_ ? @"Turn Passcode Off" : @"Turn Passcode On";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		return;
	}
	
	if (section == 1)
	{
		cell.textLabel.text = @"Change Passcode";
		cell.textLabel.textAlignment = UITextAlignmentCenter;		
		cell.textLabel.enabled = passCodeLockIsOn_;
		cell.userInteractionEnabled = passCodeLockIsOn_;
		return;	
	}
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath 
{    
    static NSString *CellIdentifier = @"LockSettingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath 
{
	if (indexPath.section == 0)
	{
		[self handleTogglePasscode];
	}
	
	if (indexPath.section == 1)
	{
		[self handleChangePasscode];
	}
}

- (void) handleTogglePasscode;
{
	NSLog(@"%s", _cmd);

	LCYPassCodeEditorViewController *passCodeEditor = [[LCYPassCodeEditorViewController alloc] initWithNibName:@"LCYPassCodeEditorViewController" bundle:nil];
	passCodeEditor.passCode = @"7890";
	passCodeEditor.delegate = self;
	
	if (passCodeLockIsOn_)
	{
		[passCodeEditor attemptToDisablePassCode];
	}
	else 
	{
		[passCodeEditor attemptToSetANewPassCode];				
	}
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:passCodeEditor];	
	[[self navigationController] presentModalViewController:navController animated:YES];
	[passCodeEditor release];
	[navController release];		
}

- (void) handleChangePasscode;
{
	NSLog(@"%s", _cmd);
	if (passCodeLockIsOn_)
	{
		// ask user for passcode input
		// ask user for new passcode
		// ask user for passcode confirm
		// 
	}
	else 
	{
		NSAssert(NO, @"Unexpected case: should never reach here");
	}
}



#pragma mark -
#pragma mark LCYPassCodeEditorDelegate protocol implementation...
- (void) passcodeEditor: (LCYPassCodeEditorViewController *) passcodeEditor newCode:(NSString *) newCode;
{
	NSLog(@"editor: %@ | newCode: %@", passcodeEditor, newCode);
	[self.navigationController dismissModalViewControllerAnimated:YES];
	if (newCode)
	{
		// TODO: save the new passcode
		passCodeLockIsOn_ = YES;
	}
	else 
	{
		passCodeLockIsOn_ = NO;
	}

	[self.tableView reloadData];	
}


@end

