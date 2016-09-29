//
//  UIImage+svgImage.m
//  AbaCloKPrototype
//
//  Created by Jeanette Müller on 23.09.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

#import "UIImage+svgImage.h"
#import <SVGKit/SVGKit.h>

@implementation UIImage (svgImage)

+ (UIImage *)svgImageNamed:(NSString *)name{
    UIImage *image;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *buildVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"];
    
    NSString *cachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@__%@.png", buildVersion, name]];

    image = [UIImage imageWithContentsOfFile:cachePath];
    
    if (!image) {
        SVGKImage *svg = [SVGKImage imageNamed:name];
        
        UIImage *newImage = svg.UIImage;
        
        if (newImage) {
            
            NSData *pngData = UIImagePNGRepresentation(newImage);
            [pngData writeToFile:cachePath atomically:YES];
            
            image = [UIImage imageWithContentsOfFile:cachePath];
            
        }else{
            NSLog(@"ERROR: SVG IMAGE could not be loaded");
        }
    }
    
    return image;
}

+ (UIImage *)svgImageNamed:(NSString *)name withSize:(CGSize)size{
    UIImage *image;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *buildVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"];
    
    NSString *cachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@__%@__%fx%f.png", buildVersion, name, size.width, size.height]];
    
    image = [UIImage imageWithContentsOfFile:cachePath];
    
    if (!image) {
        SVGKImage *svg = [SVGKImage imageNamed:name];
        
        CGFloat scale = [UIScreen mainScreen].scale;
        
        
        if (svg.hasSize) {
            
            CGSize originalSize = svg.size;
            
            CGFloat factor = originalSize.height / originalSize.width;
            
            svg.size = CGSizeMake(size.width*scale, (size.width*scale)*factor);
            
            NSLog(@"factor berechnung");
        }else{
            svg.size = CGSizeMake(size.width*scale, size.height*scale);
        }
        
        UIImage *newImage = svg.UIImage;
        
        if (newImage) {
            
            NSData *pngData = UIImagePNGRepresentation(newImage);
            [pngData writeToFile:cachePath atomically:YES];
            
            image = [UIImage imageWithContentsOfFile:cachePath];
            
        }else{
            NSLog(@"ERROR: SVG IMAGE could not be loaded");
        }
    }
    
    return image;
}

@end
