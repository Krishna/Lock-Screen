//
//  LCYLockScreen.h
//  LockScreen
//
//  Created by Krishna Kotecha on 07/11/2010.
//   Copyright 2010 Krishna Kotecha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCYPasscodeInputViewController.h"

@class LCYLockScreenViewController;

@protocol LCYLockScreenDelegate <NSObject>
- (void) lockScreen: (LCYLockScreenViewController *) lockScreen unlockedApp: (BOOL) unlocked;
@end


@interface LCYLockScreenViewController : LCYPasscodeInputViewController
{		
	UIView *enterPassCodeBanner_;
	UIView *wrongPassCodeBanner_;
	
	id<LCYLockScreenDelegate> delegate_;
	
	NSString *passCode_;	
}


@property (nonatomic, retain) IBOutlet UIView *enterPassCodeBanner;
@property (nonatomic, retain) IBOutlet UIView *wrongPassCodeBanner;

@property (nonatomic, assign) IBOutlet id<LCYLockScreenDelegate> delegate;

@property (nonatomic, copy) NSString* passCode;

@end

