//
//  LCYBannerView.h
//  LockScreen
//
//  Created by Krishna Kotecha on 28/11/2010.
//  Copyright 2010 Logic Colony Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat kBannerVIewWidth;
extern const CGFloat kBannerVIewHeight;


@interface LCYBannerView : UIView 
{
	UIColor *bannerColor_;
}

@property (nonatomic, retain) UIColor *bannerColor;

@end
