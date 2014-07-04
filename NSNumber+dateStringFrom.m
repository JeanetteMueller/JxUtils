//
//  NSNumber+dateStringFrom.m
//  Podcat
//
//  Created by Jeanette Müller on 14.05.14.
//  Copyright (c) 2014 Jeanette Müller. All rights reserved.
//

#import "NSNumber+dateStringFrom.h"
#import "NSDate+dateStringFrom.h"

@implementation NSNumber (dateStringFrom)

- (NSString *)dateStringFromNumber{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
    
    return [date dateStringFromDate];
}

@end
