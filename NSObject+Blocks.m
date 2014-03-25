//
//  NSObject.m
//  eventapp
//
//  Created by Jeanette Müller on 10.09.13.
//
//

#import "NSObject+Blocks.h"

@implementation NSObject (Blocks)

- (void)performBlock:(void (^)())block
{
    block();
}

- (void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay
{
    void (^block_)() = [block copy]; // autorelease this if you're not using ARC
    [self performSelector:@selector(performBlock:) withObject:block_ afterDelay:delay];
}

@end
