//
//  UIImage+svgImage.h
//  AbaCloKPrototype
//
//  Created by Jeanette Müller on 23.09.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (svgImage)

+ (UIImage *)svgImageNamed:(NSString *)name;
+ (UIImage *)svgImageNamed:(NSString *)name withSize:(CGSize)size;

@end
