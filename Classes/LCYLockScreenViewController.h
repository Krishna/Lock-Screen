//
//  LCYLockScreen.h
//  LockScreen
//
//  Created by Krishna Kotecha on 07/11/2010.
//  Copyright 2010 Logic Colony Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCYLockScreenViewController;

@protocol LCYLockScreenDelegate <NSObject>
- (void) lockScreen: (LCYLockScreenViewController *) lockScreen unlockedApp: (BOOL) unlocked;
@end



@interface LCYLockScreenViewController : UIViewController <UITextFieldDelegate>
{
	UIView *lockDigit_0_;
	UIView *lockDigit_1_;
	UIView *lockDigit_2_;
	UIView *lockDigit_3_;
	
	UITextField *passCodeInputField_;
	
	UIView *enterPassCodeBanner_;
	UIView *wrongPassCodeBanner_;
	
	id<LCYLockScreenDelegate> delegate_;
}

@property (nonatomic, retain) IBOutlet UIView *lockDigit_0;
@property (nonatomic, retain) IBOutlet UIView *lockDigit_1;
@property (nonatomic, retain) IBOutlet UIView *lockDigit_2;
@property (nonatomic, retain) IBOutlet UIView *lockDigit_3;

@property (nonatomic, retain) IBOutlet UITextField *passCodeInputField;

@property (nonatomic, retain) IBOutlet UIView *enterPassCodeBanner;
@property (nonatomic, retain) IBOutlet UIView *wrongPassCodeBanner;

@property (nonatomic, assign) IBOutlet id<LCYLockScreenDelegate> delegate;

@end

