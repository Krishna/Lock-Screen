//
//  RootViewController.h
//  LockScreen
//
//  Created by Krishna Kotecha on 07/11/2010.
//   Copyright 2010 Krishna Kotecha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCYDataBackedTableView.h"

@interface RootViewController : LCYDataBackedTableView 
{

}

- (IBAction) lockScreen: (id) sender;
- (void) dummySetting;
- (void) showLockScreenSettings;

@end
