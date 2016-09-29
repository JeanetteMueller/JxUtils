//
//  JxCircularProgress.m
//  AbaCloKPrototype
//
//  Created by Jeanette Müller on 06.07.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

#import "JxCircularProgress.h"

@interface JxCircularProgress () {
    CGFloat startAngle;
    CGFloat endAngle;
    CGFloat startDegree;
    CAShapeLayer *circle;
    CAShapeLayer *dot;

    
    
}

@end

@implementation JxCircularProgress

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        startDegree = -90.0;
        _textPosition = JxCircularProgressTextPositionLineEndpoint;
        
        startAngle = M_PI * 1.5;
        endAngle = startAngle + (M_PI * 2);
        _lineWidth = 10;
        _circleColor = [UIColor blueColor];
        
        
        _dotSize = CGSizeMake(5,5);
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor blueColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.userInteractionEnabled = NO;
    }
    return self;
}
- (CGFloat)radiantFrom:(CGFloat)degree{
    return degree * M_PI / 180;
}
- (CGFloat)degreeFrom:(CGFloat)radiant{
    return radiant * 180 / M_PI;
}
- (void)setPercent:(CGFloat)percent withAnimationDuration:(CGFloat)duration{
    
    //[self setPercent:percent];
    
    _percent = percent;
    CGFloat radius = (_circleSize.width - _lineWidth) / 2;
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    circle.path = [UIBezierPath bezierPathWithArcCenter:center
                                                 radius:radius
                                             startAngle:[self radiantFrom:startDegree]
                                               endAngle:[self radiantFrom:( 360.0 / 100.0 * _percent  ) + startDegree]
                                              clockwise:YES].CGPath;
    
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    circleAnimation.fromValue = @(0);
    circleAnimation.toValue = @(1);
    circleAnimation.duration = duration;
    
    [circle addAnimation:circleAnimation forKey:@"strokeEnd"];
    
    
    CGFloat degree = ((360.0/100.0*_percent) - 90) * M_PI/180;
    
    CGFloat hypotenuse = (_circleSize.width ) / 2;
    
    CGRect dotRect = CGRectMake(center.x + (hypotenuse-(_lineWidth/2)) * cos(degree) - _dotSize.width/2,
                                center.y + (hypotenuse-(_lineWidth/2)) * sin(degree) - _dotSize.height/2,
                                _dotSize.width,
                                _dotSize.height);
    dot.path = [UIBezierPath bezierPathWithOvalInRect:dotRect].CGPath;
    
    CAKeyframeAnimation *dotAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    dotAnimation.duration = duration;
    dotAnimation.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(center.x - dotRect.origin.x - _dotSize.width/2, center.y - dotRect.origin.y - _dotSize.height/2)
                                                       radius:radius
                                                   startAngle:[self radiantFrom:startDegree]
                                                     endAngle:[self radiantFrom:( 360.0 / 100.0 * _percent  ) + startDegree]
                                                    clockwise:YES].CGPath;
    dotAnimation.calculationMode = kCAAnimationPaced;
    dotAnimation.removedOnCompletion = NO;
    [dot addAnimation:dotAnimation forKey:@"position"];
    
    
    CGFloat distance = 36.f;
    CGSize textSize = CGSizeMake(70, 20);
    
    CGRect circleRect = CGRectMake(center.x-radius, center.y-radius, radius*2, radius*2);
    
    switch (_textPosition) {
        case JxCircularProgressTextPositionCenter:{
            _textLabel.frame = CGRectMake(circleRect.origin.x, circleRect.origin.y + (circleRect.size.width / 2.0) - 45/2.0, circleRect.size.width, 45);
            
        }break;
        case JxCircularProgressTextPositionBottom:{
            _textLabel.frame = CGRectMake(circleRect.origin.x, circleRect.origin.y + circleRect.size.height, circleRect.size.width, 45);
            
        }break;
        case JxCircularProgressTextPositionLineEndpoint:{
            
            _textLabel.frame = CGRectMake(center.x + (hypotenuse+distance-(_lineWidth/2)) * cos(degree) - textSize.width/2,
                                    center.y + (hypotenuse+distance-(_lineWidth/2)) * sin(degree) - textSize.height/2,
                                    textSize.width,
                                    textSize.height);
            CAKeyframeAnimation *textAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            textAnimation.duration = duration;
            textAnimation.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(center.x , center.y )
                                                                radius:radius+distance
                                                            startAngle:[self radiantFrom:startDegree]
                                                              endAngle:[self radiantFrom:( 360.0 / 100.0 * _percent  ) + startDegree]
                                                             clockwise:YES].CGPath;
            textAnimation.calculationMode = kCAAnimationPaced;
            textAnimation.removedOnCompletion = NO;
            [_textLabel.layer addAnimation:textAnimation forKey:@"position"];
            
        }break;
        default:
            break;
    }
}

- (void)setPercent:(CGFloat)percent{
    _percent = percent;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    if (!circle) {
        circle = [CAShapeLayer layer];
        circle.fillColor = nil;
        circle.strokeColor = _circleColor.CGColor;
        circle.lineWidth = _lineWidth;
        [self.layer addSublayer:circle];
    }
    
    if (!dot) {
        dot = [CAShapeLayer layer];
        dot.fillColor = _circleColor.CGColor;
        
        [self.layer addSublayer:dot];
    }
    
    if (_textPosition != JxCircularProgressTextPositionNone) {
        [self addSubview:_textLabel];
    }
}
- (void)setProgressText:(NSString *)progressText{
    _textLabel.text = progressText;
    
    [self setNeedsDisplay];
}

@end
