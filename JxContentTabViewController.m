//
//  JxContentTabViewController.m
//  PageView
//
//  Created by Jeanette Müller on 19.04.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

#import "JxContentTabViewController.h"

@interface JxContentTabViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate>

@property (assign, nonatomic) BOOL initialLoad;

@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray *controllers;



@property (strong, nonatomic) IBOutlet UIView *buttonContainer;

@property (strong, nonatomic) IBOutlet UIView *pageContainer;

@property (strong, nonatomic) IBOutlet UIView *activeMarker;

@property (strong, nonatomic) NSMutableArray *buttons;

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) UIScrollView *pageViewScrollView;

@end

@implementation JxContentTabViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setInitialPropertys];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setInitialPropertys];
    }
    return self;
}
- (void)setInitialPropertys{
    
    self.titles = [NSMutableArray array];
    self.controllers = [NSMutableArray array];
    
    _titleFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    _titleColor = [UIColor darkGrayColor];
    _titleBackgroundColor = [UIColor whiteColor];
    _activeMarkerColor = [UIColor darkGrayColor];
    _buttonSeperatorColor = [UIColor colorWithWhite:.92 alpha:1];
    
    _buttonSeperatorWidth = 1.0f;
    _activeMarkerHeight = 4;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _activeMarker.hidden = YES;
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    _pageViewController.view.frame = CGRectMake(0, 0, self.pageContainer.frame.size.width, self.pageContainer.frame.size.height);
    _pageViewController.view.backgroundColor = [UIColor whiteColor];
    [self.pageContainer addSubview:_pageViewController.view];
    
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    
    for (UIView *view in self.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)view setDelegate:self];
            self.pageViewScrollView = (UIScrollView *)view;
        }
    }
    
    self.pageViewScrollView.scrollEnabled = NO;
}
- (void)viewDidLayoutSubviews{
    if (!_initialLoad) {
        self.initialLoad = YES;
        
        
        _buttonContainer.backgroundColor = _buttonSeperatorColor;
        _activeMarker.backgroundColor = _activeMarkerColor;
        
        if (_controllers.count == 0) {
            
            UIViewController *dummy = [[UIViewController alloc] init];
            dummy.view.backgroundColor = [UIColor cyanColor];
            
            self.controllers = [@[dummy] mutableCopy];
            self.titles = [@[@"dummy"] mutableCopy];
        }
        [_pageViewController setViewControllers:@[[_controllers objectAtIndex:_startIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
        
        
        
        
        CGFloat buttonWidth = (self.view.frame.size.width - (_titles.count-1)*_buttonSeperatorWidth) /_titles.count;
        CGFloat buttonHeight = self.buttonContainer.frame.size.height-_activeMarkerHeight;
        
        for (int index = 0; index < _titles.count; index++) {
            
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [b setTitle:[_titles objectAtIndex:index] forState:UIControlStateNormal];
            [b setTitleColor:_titleColor forState:UIControlStateNormal];
            b.titleLabel.font = _titleFont;
            [b addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            b.backgroundColor = _titleBackgroundColor;
            
            
            
            b.frame = CGRectMake(index * (buttonWidth + _buttonSeperatorWidth), 0, buttonWidth, buttonHeight);
            [_buttonContainer addSubview:b];
        }
    }
    
    [super viewDidLayoutSubviews];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self updateActivityMarkerWithIndex:[self currentIndex]];
}
#pragma mark Transitions

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    NSLog(@"rotation");
  
  __weak __typeof(self) weakSelf = self;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        CGFloat buttonWidth = (size.width - (weakSelf.titles.count-1)*weakSelf.buttonSeperatorWidth) /weakSelf.titles.count;
        CGFloat buttonHeight = weakSelf.buttonContainer.frame.size.height-weakSelf.activeMarkerHeight;
        
        NSInteger buttonIndex = 0;
        for (UIButton *b in self.buttonContainer.subviews) {
            if ([b isKindOfClass:[UIButton class]]) {
                b.frame = CGRectMake(buttonIndex * (buttonWidth + weakSelf.buttonSeperatorWidth), 0, buttonWidth, buttonHeight);
            }
        }
        
        [self updateActivityMarkerWithIndex:[self currentIndex]];
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}
-(void) setSelectedIndex:(NSInteger)selectedIndex{
    [self setSelectedIndex:selectedIndex animated:YES];
}
-(void) setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated{
    if (_controllers.count > selectedIndex) {
        UIPageViewControllerNavigationDirection direction = UIPageViewControllerNavigationDirectionForward;
        
        if (selectedIndex < [self currentIndex]) {
            direction = UIPageViewControllerNavigationDirectionReverse;
        }
        
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                [self updateActivityMarkerWithIndex:selectedIndex];
            }];
        }else{
            [self updateActivityMarkerWithIndex:selectedIndex];
        }
        
        
        [_pageViewController setViewControllers:@[[_controllers objectAtIndex:selectedIndex]] direction:direction animated:animated completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark Getter
- (NSInteger)selectedIndex {
    return [self currentIndex];
}

#pragma mark Actions
- (IBAction)buttonAction:(UIButton *)sender{
    
    NSInteger index = [self.titles indexOfObject:[sender titleLabel].text];
    
    self.selectedIndex = index;
    
}
#pragma mark Manipulations

- (void)addTabWithTitle:(NSString *)title andController:(id)controller{
    [self addTabWithTitle:title andController:controller atIndex:self.titles.count];
}
- (void)addTabWithTitle:(NSString *)title andController:(id)controller atIndex:(NSInteger)index{
    [self addTabWithTitle:title andController:controller atIndex:index animated:YES];
}
- (void)addTabWithTitle:(NSString *)title andController:(id)controller atIndex:(NSInteger)index animated:(BOOL)animated{
    
    if (index > self.titles.count || index < 0) {
        index = self.titles.count;
    }
    
    if ([self.titles.firstObject isEqualToString:@"dummy"]) {
        [self.titles removeAllObjects];
        [self.controllers removeAllObjects];
    }
    
    [self.titles insertObject:title atIndex:index];
    [self.controllers insertObject:controller atIndex:index];
    
    CGFloat buttonWidth = (self.view.frame.size.width - (_titles.count-1)*_buttonSeperatorWidth) /_titles.count;
    CGFloat buttonHeight = self.buttonContainer.frame.size.height-_activeMarkerHeight;
    
    
    if (_initialLoad){
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [b setTitle:[_titles objectAtIndex:index] forState:UIControlStateNormal];
        [b setTitleColor:_titleColor forState:UIControlStateNormal];
        b.titleLabel.font = _titleFont;
        [b addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        b.backgroundColor = _titleBackgroundColor;
        
        b.frame = CGRectMake(self.view.frame.size.width, 0, buttonWidth, buttonHeight);
        [_buttonContainer addSubview:b];
    }

    void (^animation1)(void) = ^{
        
        NSInteger buttonIndex = 0;
        for (UIButton *b in self.buttonContainer.subviews) {
            if ([b isKindOfClass:[UIButton class]]) {
                b.frame = CGRectMake(buttonIndex * (buttonWidth + self->_buttonSeperatorWidth), 0, buttonWidth, buttonHeight);
                buttonIndex++;
                
            }
            
        }
        [self updateActivityMarkerWithIndex:[self currentIndex]];
        
    };
    void (^completion1)(BOOL finished) = ^(BOOL finished) {
    
    };
    
    
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:animation1
                         completion:completion1];
    }else{
        animation1();
        completion1(YES);
    }
}
- (void)addTabWithTitle:(NSString *)title andController:(id)controller animated:(BOOL)animated{
    [self addTabWithTitle:title andController:controller atIndex:self.titles.count animated:animated];
}
- (void)removeTabfromIndex:(NSInteger)index{
    [self removeTabfromIndex:index animated:YES];
}
- (void)removeTabfromIndex:(NSInteger)index animated:(BOOL)animated{
    
    if (index >= 0 && index < self.titles.count && self.titles.count-1 > 0) {
        
        __weak __typeof(self)weakSelf = self;
        
        NSInteger oldIndex = [self currentIndex];
        
        [self.titles removeObjectAtIndex:index];
        [self.controllers removeObjectAtIndex:index];
        
        if (index == oldIndex) {
            [self setSelectedIndex:0 animated:animated];
        }

        CGSize size = self.view.bounds.size;
        
        CGFloat buttonWidth = (size.width - (_titles.count-1)*_buttonSeperatorWidth) /_titles.count;
        CGFloat buttonHeight = _buttonContainer.frame.size.height-_activeMarkerHeight;
        
        
        void (^animation1)(void) = ^{
            for (UIButton *b in self.buttonContainer.subviews) {
                if ([b isKindOfClass:[UIButton class]]) {
                    if (![weakSelf.titles containsObject:b.titleLabel.text]) {
                        
                        b.alpha = 0.0f;
                    }
                }
            }
            if (index != oldIndex) {
                //[weakSelf updateActivityMarkerWithIndex:[weakSelf currentIndex]];
            }
        };
        
        void (^animation2)(void) = ^{
            
            NSInteger buttonIndex = 0;
            for (UIButton *b in weakSelf.buttonContainer.subviews) {
                if ([b isKindOfClass:[UIButton class]]) {
                    if (![weakSelf.titles containsObject:b.titleLabel.text]) {
                        
                        
                    }else{
                        b.frame = CGRectMake(buttonIndex * (buttonWidth + weakSelf.buttonSeperatorWidth), 0, buttonWidth, buttonHeight);
                        buttonIndex++;
                    }
                }
                
            }
            if (index != oldIndex) {
                [weakSelf updateActivityMarkerWithIndex:[weakSelf currentIndex]];
            }
        };
        
        void (^completion1)(BOOL finished) = ^(BOOL finished) {
            
            for (UIButton *b in self.buttonContainer.subviews) {
                if ([b isKindOfClass:[UIButton class]]) {
                    if (![weakSelf.titles containsObject:b.titleLabel.text]) {
                        
                        [b removeFromSuperview];
                    }
                }
            }
            
            if (animated) {
                [UIView animateWithDuration:0.3
                                 animations:animation2];
            }
            
        };
        
        
        if (animated) {
            [UIView animateWithDuration:0.3
                             animations:animation1
                             completion:completion1];
        }else{
            animation1();
            completion1(YES);
            animation2();
        }
    }
}

#pragma mark <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    //[self updateActivitymarker];
}
- (void)updateActivityMarkerWithIndex:(NSInteger)index{
    
    CGFloat buttonWidth = (self.view.frame.size.width - (_titles.count-1)*_buttonSeperatorWidth) /_titles.count;
    
    _activeMarker.frame = CGRectMake(index*buttonWidth + index * _buttonSeperatorWidth,
                                     self.buttonContainer.frame.size.height-_activeMarkerHeight,
                                     buttonWidth,
                                     _activeMarkerHeight);
    _activeMarker.hidden = NO;
  [self.delegate controller:self didSelectIndex:index];
}

#pragma mark <UIPageViewControllerDataSource>

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{

    UIViewController *last = nil;
    for (UIViewController *c in _controllers) {
        if ([c isEqual:viewController]) {
            return last;
        }else{
            last = c;
        }
    }
    
    return nil;
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    int index = 0;
    for (UIViewController *c in _controllers) {
        if ([c isEqual:viewController]) {
            
            
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
- (NSInteger)currentIndex{
    NSInteger index = 0;
    for (UIViewController *c in _controllers) {
        if ([c isEqual:self.pageViewController.viewControllers.firstObject]) {
            return index;
        }
        index++;
    }
    return 0;
}
@end
