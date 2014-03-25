//
//  JxPagingViewController.h
//  Bikes1000
//
//  Created by Jeanette Müller on 21.03.14.
//  Copyright (c) 2014 Motorpresse Stuttgart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JxPagingViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *controllers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil viewControllers:(NSArray *)controllers;

@end
