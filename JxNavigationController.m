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

- (NSUInteger)supportedInterfaceOrientations{
    return _allowedInterfaceOrientations;
}


@end
