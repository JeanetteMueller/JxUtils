//
//  NSString+Trim.m
//  Podcat
//
//  Created by Jeanette Müller on 03.08.15.
//  Copyright (c) 2015 Jeanette Müller. All rights reserved.
//

#import "NSString+Trim.h"

@implementation NSString (Trim)

- (NSString *)trim
{
    NSMutableString *str = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@", self]];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)str);
    return str;
}
@end
