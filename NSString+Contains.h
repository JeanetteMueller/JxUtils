//
//  NSString+Contains.h
//  Podcat
//
//  Created by Jeanette Müller on 22.09.14.
//  Copyright (c) 2014 Jeanette Müller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Contains)

- (BOOL)containsString:(NSString *)string;
- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options;

@end
