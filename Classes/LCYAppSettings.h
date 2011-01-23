//
//  LCYAppSettings.h
//  LockScreen
//
//  Created by Krishna Kotecha on 27/11/2010.
//   Copyright 2010 Krishna Kotecha. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LCYAppSettings : NSObject 
{
	BOOL lockScreenPasscodeIsOn_;
	NSString *lockScreenPasscode_;	
}

@property (nonatomic, assign) BOOL lockScreenPasscodeIsOn;
@property (nonatomic, retain) NSString *lockScreenPasscode;

- (BOOL) synchronize;

@end
