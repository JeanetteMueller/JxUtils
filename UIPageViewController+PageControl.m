//
//  UIPageViewController+PageControl.m
//  Podcat
//
//  Created by Jeanette Müller on 28.01.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

#import "UIPageViewController+PageControl.h"

@implementation UIPageViewController (PageControl)

- (UIPageControl *)pageControl
{
    __block UIPageControl *pageControl = nil;
    void (^pageControlAssignBlock)(UIPageControl *) = ^void(UIPageControl *blockPageControl) {
        pageControl = blockPageControl;
    };
    
    [self recurseForPageControlFromSubViews:self.view.subviews withAssignBlock:pageControlAssignBlock];
    
    return pageControl;
}

- (void)recurseForPageControlFromSubViews:(NSArray *)subViews withAssignBlock:(void (^)(UIPageControl *))assignBlock
{
    for (UIView *subView in subViews) {
        if ([subView isKindOfClass:[UIPageControl class]]) {
            assignBlock((UIPageControl *)subView);
            break;
        } else {
            [self recurseForPageControlFromSubViews:subView.subviews withAssignBlock:assignBlock];
        }
    }
}

@end
