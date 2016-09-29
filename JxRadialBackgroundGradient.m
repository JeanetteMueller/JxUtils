//
//  JxRadialBackgroundGradient.m
//  AbaCloKPrototype
//
//  Created by Jeanette Müller on 29.06.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

#import "JxRadialBackgroundGradient.h"

@implementation JxRadialBackgroundGradient


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.radialCenter = CGPointMake(-1, -1);
        [self setNeedsDisplay];
    }
    return self;
}



- (void)drawInContext:(CGContextRef)ctx
{
    if(CGPointEqualToPoint(self.radialCenter, CGPointMake(-1, -1))){
        self.radialCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height + (self.bounds.size.height/8));
    }
    
    
    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    [_innerRadialColor getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [_outerRadialColor getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    
    size_t gradLocationsNum = 2;
    CGFloat gradLocations[2] = {0.0f, 1.0f};
    CGFloat gradColors[8] = {
        r1, g1, b1, a1,
        r2, g2, b2, a2
    };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
    CGColorSpaceRelease(colorSpace);
    
    
    float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
    
    CGContextDrawRadialGradient (ctx, gradient, self.radialCenter, 0, self.radialCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient);
}

@end
