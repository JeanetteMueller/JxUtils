//
//  UIView+Rotate.m
//  Podcat
//
//  Created by Jeanette Müller on 28.11.14.
//  Copyright (c) 2014 Jeanette Müller. All rights reserved.
//

#import "UIView+Rotate.h"

@implementation UIView (Rotate)

- (void)rotate360WithDuration:(CGFloat)duration repeatCount:(float)repeatCount clockwise:(BOOL)clockwise
{
    
    CABasicAnimation *fullRotation;
    fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = [NSNumber numberWithFloat:0];
    if (clockwise) {
        fullRotation.toValue = [NSNumber numberWithFloat:DegreesToRadians(360)];
    }else{
        fullRotation.toValue = [NSNumber numberWithFloat:-(DegreesToRadians(360))]; // added this minus sign as i want to rotate it to anticlockwise
    }
    fullRotation.duration = duration;
    fullRotation.speed = 2.0f;              // Changed rotation speed
    if (repeatCount == 0)
        fullRotation.repeatCount = MAXFLOAT;
    else
        fullRotation.repeatCount = repeatCount;
    
    [self.layer addAnimation:fullRotation forKey:@"360"];
}

//Not using this methods :)

- (void)stopAllAnimations
{
    
    [self.layer removeAllAnimations];
};

- (void)pauseAnimations
{
    
    [self pauseLayer:self.layer];
}

- (void)resumeAnimations
{
    
    [self resumeLayer:self.layer];
}

- (void)pauseLayer:(CALayer *)layer
{
    
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

- (void)resumeLayer:(CALayer *)layer
{
    
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

@end

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
