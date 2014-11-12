//
//  NSDate+dateStringFrom.m
//  Podcat
//
//  Created by Jeanette Müller on 14.05.14.
//  Copyright (c) 2014 Jeanette Müller. All rights reserved.
//

#import "NSDate+dateStringFrom.h"

@implementation NSDate (dateStringFrom)

- (NSString *)dateStringFromDate{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM yyyy"];
    [formatter setLocale:[NSLocale autoupdatingCurrentLocale]];
    
    
    NSString *formattedDateString = [formatter stringFromDate:self];
    
    //NSLog(@"formattedDateString for locale %@: %@", [[formatter locale] localeIdentifier], formattedDateString);
    
    NSLog(@"formattedDateString: %@", formattedDateString);
    
    return formattedDateString;
}

@end
