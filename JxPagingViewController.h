//
//  JxPagingViewController.h
//
//  Created by Jeanette Müller on 21.03.14.
//  MIT Licence
//

#import <UIKit/UIKit.h>

@interface JxPagingViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *controllers;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil viewControllers:(NSArray *)controllers;

@end
