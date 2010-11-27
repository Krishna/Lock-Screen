//
//  LCYLockSettingsViewController.h
//  LockScreen
//
//  Created by Krishna Kotecha on 22/11/2010.
//  Copyright 2010 Logic Colony Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LCYPassCodeEditorViewController.h"

@interface LCYLockSettingsViewController : UITableViewController  <LCYPassCodeEditorDelegate>
{
	NSArray *sectionTitles_;
}

// LCYPassCodeEditorDelegate protocol...
- (void) passcodeEditor: (LCYPassCodeEditorViewController *) passcodeEditor newCode:(NSString *) newCode;

- (BOOL) passCodeLockIsOn;
- (NSString *) currentPasscode;
- (void) updatePasscodeSettings: (NSString *) newCode;

@end
