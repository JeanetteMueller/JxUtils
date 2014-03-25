//
//  NSObject.h
//  eventapp
//
//  Created by Jeanette Müller on 10.09.13.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (Blocks)

- (void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay;

@end
