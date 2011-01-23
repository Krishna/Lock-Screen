//
//  LCYDataBackedTableView.m
//
//  Created by Krishna Kotecha on 27/11/2010.
//  Copyright 2010 Krishna Kotecha. All rights reserved.
//

#import "LCYDataBackedTableView.h"


@implementation LCYDataBackedTableView

#pragma mark -
#pragma mark Memory management

- (void) dealloc 
{	
    [dataToShow_ release];
    dataToShow_ = nil;  
    [super dealloc];
}

#pragma mark -
#pragma mark Data Access Helpers

- (void) loadTableDataFromPath: (NSString *) path;
{
	dataToShow_ = [[NSDictionary dictionaryWithContentsOfFile:path] retain];
/*	
	NSLog(@"%s ! %@", _cmd, [dataToShow_ objectForKey:[NSNumber numberWithInt:0]]);
	NSLog(@"%s ! %@", _cmd, [dataToShow_ objectForKey:[NSNumber numberWithInt:1]]);	
	
	NSLog(@" all keys: %@", [dataToShow_  allKeys]);
	NSLog(@" all values: %@", [dataToShow_  allValues]);	
	
	for(id k in [dataToShow_ allKeys])
	{
		NSLog(@"k: %@ (%@) -> %@", k, [k class], [dataToShow_ objectForKey:k]);
	}	
*/
}

- (void) setDataUsingDictionary: (NSDictionary *) dictionary;
{
	dataToShow_ = [dictionary copy];
}

- (NSString *) keyForSection:(int) section; 
{
	return [NSString stringWithFormat:@"%d", section];
}

- (NSString *) keyForSectionTitle:(int) section; 
{
	return [NSString stringWithFormat:@"sectionTitle%d", section];
}

- (NSArray *) dataForIndexPath: (NSIndexPath *) indexPath;
{
    NSArray *arrayForSection = [dataToShow_ objectForKey:[self keyForSection:indexPath.section]];		
    NSArray *dataToShow = (NSArray *) [arrayForSection objectAtIndex:indexPath.row];
	return dataToShow;
}

- (NSString *) cellTextForIndexPath: (NSIndexPath *) indexPath;
{
	NSArray *dataToShow = [self dataForIndexPath: indexPath];
	return [dataToShow objectAtIndex:0];	
}

- (NSString *) selectorNameForIndexPath: (NSIndexPath *) indexPath;
{
	NSArray *dataToShow = [self dataForIndexPath: indexPath];
    return [dataToShow objectAtIndex:1];	
}

- (UITableViewCellAccessoryType) cellAccessoryTypeForIndexPath: (NSIndexPath *) indexPath;
{
	NSArray *dataToShow = [self dataForIndexPath: indexPath];
	
	NSString *accessoryType = [dataToShow objectAtIndex:2];
	
	if ([accessoryType isEqualToString:@"disclosure"]) 
	{
		return UITableViewCellAccessoryDisclosureIndicator;
	}
	
	if ([accessoryType isEqualToString:@"detailDisclosureButton"]) 
	{
		return UITableViewCellAccessoryDetailDisclosureButton;
	}
	
	if ([accessoryType isEqualToString:@"checkmark"]) 
	{
		return UITableViewCellAccessoryCheckmark;
	}
	
	return UITableViewCellAccessoryNone;
}

- (void) configureCell: (UITableViewCell *) cell forIndexPath: (NSIndexPath *) indexPath;
{
	cell.textLabel.text = [self cellTextForIndexPath: indexPath];
	cell.accessoryType = [self cellAccessoryTypeForIndexPath: indexPath];
}

#pragma mark -
#pragma mark View lifecycle

- (void) viewDidUnload 
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	
    [dataToShow_ release];
    dataToShow_ = nil;
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView 
{	
    int result =  [dataToShow_ allKeys].count;
    return result;
}

// Customize the number of rows in the table view.
- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section 
{	
    NSArray *arrayForSection = [dataToShow_ objectForKey:[self keyForSection:section]];	
    int result =  [arrayForSection count];
    return result;	
}


- (NSString *) tableView: (UITableView *) tableView titleForHeaderInSection: (NSInteger) section 
{
	return [dataToShow_ objectForKey:[self keyForSectionTitle:section]];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DataBackedTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	[self configureCell: cell forIndexPath: indexPath];	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{	
	NSString *selectorName = [self selectorNameForIndexPath: indexPath];
	if (selectorName)
	{
		[self performSelector:NSSelectorFromString(selectorName)];
	}
}


@end
