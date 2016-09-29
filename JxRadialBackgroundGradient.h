//
//  JxRadialBackgroundGradient.h
//  AbaCloKPrototype
//
//  Created by Jeanette Müller on 29.06.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JxRadialBackgroundGradient : CALayer

@property (strong, nonatomic) UIColor *innerRadialColor;
@property (strong, nonatomic) UIColor *outerRadialColor;

@property (assign, nonatomic) CGPoint radialCenter;
@end
