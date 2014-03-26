//
//  JxPagingViewController.m
//
//  Created by Jeanette Müller on 21.03.14.
//  MIT Licence
//

#import "JxPagingViewController.h"
#import "Logging.h"

@interface JxPagingViewController ()

@property (strong, nonatomic) IBOutlet UIPageViewController *pageViewController;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@end

@implementation JxPagingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil viewControllers:(NSArray *)controllers
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.controllers = controllers;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    
    
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    _pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _pageViewController.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_pageViewController.view];
    
    [self.pageViewController.view.subviews[0] setDelegate:self];
    
    [_pageViewController setViewControllers:@[[_controllers firstObject]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    //_closeButton.backgroundColor = [UIColor lightGrayColor];
    [_closeButton setTitle:NSLocalizedString(@"Close Window", @"") forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(action_close:) forControlEvents:UIControlEventTouchUpInside];
    
    [_closeButton setFrame:CGRectMake(self.view.frame.size.width-40, 0, 40, 40)];
    _closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
    
    [self.view addSubview:_closeButton];
    
    [_closeButton sizeToFit];
    
    CGFloat buttonHeight = _closeButton.frame.size.height;
    CGFloat buttonWidth = _closeButton.frame.size.width;
    
    if (buttonHeight < 40.0f) {
        buttonHeight = 40.0f;
    }
    CGFloat extraWidth = 20;
    
    buttonWidth = buttonWidth+extraWidth;
    
    [_closeButton setFrame:CGRectMake(self.view.frame.size.width-buttonWidth, 0, buttonWidth, buttonHeight)];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}
- (IBAction)action_close:(id)sender{
    LLog();
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    LLog();
    
    UIViewController *last = nil;;
    for (UIViewController *c in _controllers) {
        if ([c isKindOfClass:viewController.class]) {
            return last;
        }else{
            last = c;
        }
    }
    
    return nil;
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    LLog();
    
    int index = 0;
    for (UIViewController *c in _controllers) {
        if ([c isKindOfClass:viewController.class]) {
            
            
            UIViewController *next = nil;
            
            if ([_controllers count] > index+1) {
                next = [_controllers objectAtIndex:index+1];
            }
            
            return next;
        }
        index++;
    }
    
    return nil;
}
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return [_controllers count];
}
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return 0;
}

@end
