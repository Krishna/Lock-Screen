//
//  LCYPasscodeInputHandler.h
//  LockScreen
//
//  Created by Krishna Kotecha on 28/11/2010.
//  Copyright 2010 Logic Colony Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LCYPasscodeInputViewController : UIViewController <UITextFieldDelegate>
{
	UIView *lockDigit_0_;
	UIView *lockDigit_1_;
	UIView *lockDigit_2_;
	UIView *lockDigit_3_;
	
	UITextField *passCodeInputField_;	
}

@property (nonatomic, retain) IBOutlet UIView *lockDigit_0;
@property (nonatomic, retain) IBOutlet UIView *lockDigit_1;
@property (nonatomic, retain) IBOutlet UIView *lockDigit_2;
@property (nonatomic, retain) IBOutlet UIView *lockDigit_3;

@property (nonatomic, retain) IBOutlet UITextField *passCodeInputField;

- (void) resetUIState;

@end
