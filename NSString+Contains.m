//
//  NSString+Contains.m
//  Podcat
//
//  Created by Jeanette Müller on 22.09.14.
//  Copyright (c) 2014 Jeanette Müller. All rights reserved.
//

#import "NSString+Contains.h"

@implementation NSString (Contains)

- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL)containsString:(NSString *)string {
    return [self containsString:string options:0];
}

@end
