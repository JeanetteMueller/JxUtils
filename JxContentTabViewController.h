//
//  JxContentTabViewController.h
//  PageView
//
//  Created by Jeanette Müller on 19.04.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JxContentTabViewControllerDelegate;

@interface JxContentTabViewController : UIViewController

@property (assign, nonatomic) NSInteger startIndex;
@property (assign, nonatomic) NSInteger selectedIndex;

@property (strong, nonatomic, readonly) NSMutableArray *titles;
@property (strong, nonatomic, readonly) NSMutableArray *controllers;

@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIColor *titleBackgroundColor;
@property (strong, nonatomic) UIColor *activeMarkerColor;
@property (strong, nonatomic) UIColor *buttonSeperatorColor;

@property (assign, nonatomic) CGFloat buttonSeperatorWidth;
@property (assign, nonatomic) CGFloat activeMarkerHeight;

@property (nonatomic, unsafe_unretained) IBOutlet id<JxContentTabViewControllerDelegate> delegate;

- (void)addTabWithTitle:(NSString *)title andController:(id)controller;
- (void)addTabWithTitle:(NSString *)title andController:(id)controller atIndex:(NSInteger)index;
- (void)addTabWithTitle:(NSString *)title andController:(id)controller atIndex:(NSInteger)index animated:(BOOL)animated;
- (void)addTabWithTitle:(NSString *)title andController:(id)controller animated:(BOOL)animated;

- (void)removeTabfromIndex:(NSInteger)index;
- (void)removeTabfromIndex:(NSInteger)index animated:(BOOL)animated;

@end









@protocol JxContentTabViewControllerDelegate <NSObject>
-(void) controller:(JxContentTabViewController*) controller didSelectIndex:(NSUInteger) index;
@end
