//
//  LCYLockDigitView.h
//  LockScreen
//
//  Created by Krishna Kotecha on 28/11/2010.
//   Copyright 2010 Krishna Kotecha. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat kDigitViewWidth;
extern const CGFloat kDigitViewHeight;

@interface LCYLockDigitView : UIView 
{
	BOOL isFilled_;
}

@property (nonatomic, assign) BOOL isFilled;

@end
