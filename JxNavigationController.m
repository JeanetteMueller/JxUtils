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


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Woverriding-method-mismatch"
#pragma clang diagnostic ignored "-Wmismatched-return-types"
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return _allowedInterfaceOrientations;
}
#pragma clang diagnostic pop


@end
