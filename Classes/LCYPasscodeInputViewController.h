//
//  LCYPasscodeInputHandler.h
//  LockScreen
//
//  Created by Krishna Kotecha on 28/11/2010.
//  Copyright 2010 Logic Colony Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCYLockDigitView;

@interface LCYPasscodeInputViewController : UIViewController <UITextFieldDelegate>
{
	LCYLockDigitView *lockDigit_0_;
	LCYLockDigitView *lockDigit_1_;
	LCYLockDigitView *lockDigit_2_;
	LCYLockDigitView *lockDigit_3_;
	
	UITextField *passCodeInputField_;	
}

@property (nonatomic, retain) IBOutlet LCYLockDigitView *lockDigit_0;
@property (nonatomic, retain) IBOutlet LCYLockDigitView *lockDigit_1;
@property (nonatomic, retain) IBOutlet LCYLockDigitView *lockDigit_2;
@property (nonatomic, retain) IBOutlet LCYLockDigitView *lockDigit_3;

@property (nonatomic, retain) IBOutlet UITextField *passCodeInputField;

- (void) resetUIState;

@end
