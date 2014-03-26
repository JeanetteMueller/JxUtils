//
//  JxPagingViewController.h
//
//  Created by Jeanette Müller on 21.03.14.
//  MIT Licence
//

#import <UIKit/UIKit.h>

@interface JxPagingViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *controllers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil viewControllers:(NSArray *)controllers;

@end
