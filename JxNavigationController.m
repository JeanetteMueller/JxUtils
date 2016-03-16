//
//  JxNavigationController.m
//
//  Created by Jeanette Müller on 26.12.11.
//  MIT Licence
//

#import "JxNavigationController.h"

@implementation JxNavigationController

#pragma mark Rotation

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return _allowedInterfaceOrientations;
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        
//
//        
//        self.navigationBar.frame = CGRectMake(self.navigationBar.frame.origin.x, self.navigationBar.frame.origin.y,
//                                              414, self.navigationBar.frame.size.height);
//        
//    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        
//        self.navigationBar.frame = CGRectMake(self.navigationBar.frame.origin.x, self.navigationBar.frame.origin.y,
//                                              414, self.navigationBar.frame.size.height);
//        
//        
//        DLog(@"self.navigationBar.frame.size.width %f", self.navigationBar.frame.size.width);
//        
//    }];
    
    
    
    
}
@end
