//
//  NSObject+Blocks.h
//
//  Created by Jeanette Müller on 10.09.13.
//  MIT Licence
//

#import <Foundation/Foundation.h>

@interface NSObject (Blocks)

- (void)performBlock:(void (^)())block;
- (void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay;

@end
