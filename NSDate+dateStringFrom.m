//
//  NSDate+dateStringFrom.m
//  Podcat
//
//  Created by Jeanette Müller on 14.05.14.
//  Copyright (c) 2014 Jeanette Müller. All rights reserved.
//

#import "NSDate+dateStringFrom.h"

@implementation NSDate (dateStringFrom)

+ (NSDateFormatter *)sharedDateFormatter{
    static NSDateFormatter *sharedDateFormatter = nil;
    static dispatch_once_t pred;
    
    if (sharedDateFormatter) return sharedDateFormatter;
    
    dispatch_once(&pred, ^{
        sharedDateFormatter = [[NSDateFormatter alloc] init];
    });
    
    return sharedDateFormatter;
}

- (NSString *)dateStringFromDate{
    
    NSDateFormatter* formatter = [NSDate sharedDateFormatter];
    [formatter setDateFormat:@"MMMM yyyy"];
    [formatter setLocale:[NSLocale autoupdatingCurrentLocale]];
    
    
    NSString *formattedDateString = [formatter stringFromDate:self];
    
    //NSLog(@"formattedDateString for locale %@: %@", [[formatter locale] localeIdentifier], formattedDateString);
    
    //NSLog(@"formattedDateString: %@", formattedDateString);
    
    return formattedDateString;
}

@end
