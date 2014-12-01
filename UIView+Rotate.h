//
//  UIView+Rotate.h
//  Podcat
//
//  Created by Jeanette Müller on 28.11.14.
//  Copyright (c) 2014 Jeanette Müller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Rotate)

- (void)rotate360WithDuration:(CGFloat)duration repeatCount:(float)repeatCount clockwise:(BOOL)clockwise;
- (void)pauseAnimations;
- (void)resumeAnimations;
- (void)stopAllAnimations;

@end

CGFloat DegreesToRadians(CGFloat degrees);