//
//  UIColor+HexString.h
//
//  Created by Jeanette Müller on 23.04.12.
//  MIT Licence
//

#import <Foundation/Foundation.h>

@interface UIColor (HexString)

+ (UIColor *) colorWithHexString: (NSString *) hexString;
+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;

@end
