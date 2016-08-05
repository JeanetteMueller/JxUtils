//
//  UIImageView+BlurImage.m
//  Podcat
//
//  Created by Jeanette Müller on 15.06.16.
//  Copyright © 2016 Jeanette M√ºller. All rights reserved.
//

#import "UIView+Blur.h"

@implementation UIView (Blur)

- (void)blur{
    if (![self viewWithTag:53253]) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurView.userInteractionEnabled = NO;
        blurView.tag = 53253;
        blurView.frame = self.bounds;
        blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:blurView];
    }
}
- (void)unBlur{
    [[self viewWithTag:53253] removeFromSuperview];
}

@end
