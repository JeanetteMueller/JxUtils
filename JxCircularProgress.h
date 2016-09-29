//
//  JxCircularProgress.h
//  AbaCloKPrototype
//
//  Created by Jeanette Müller on 06.07.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JxCircularProgressTextPosition) {
    JxCircularProgressTextPositionNone = -1,
    JxCircularProgressTextPositionCenter, //default
    JxCircularProgressTextPositionBottom,
    JxCircularProgressTextPositionLineEndpoint
};

@interface JxCircularProgress : UIView

@property (assign, nonatomic) JxCircularProgressTextPosition textPosition;

@property (assign, nonatomic) CGSize circleSize;
@property (assign, nonatomic) CGSize dotSize;
@property (strong, nonatomic) UIColor *circleColor;

@property (assign, nonatomic) CGFloat percent;
@property (assign, nonatomic) CGFloat lineWidth;

@property (strong, nonatomic) UILabel *textLabel;

- (void)setPercent:(CGFloat)percent withAnimationDuration:(CGFloat)duration;

- (void)setProgressText:(NSString *)progressText;
@end
