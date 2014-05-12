//
//  UIView+RenderAsImage.m
//
//  Created by Jeanette Müller on 25.03.14.
//  MIT Licence
//

#import "UIView+RenderAsImage.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (RenderAsImage)

- (UIImage *)renderAsImage{
    
    CGSize imageSize = self.bounds.size;
    // Create a graphics context with the target size
    
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    if (NULL != UIGraphicsBeginImageContextWithOptions){
        UIGraphicsBeginImageContextWithOptions(imageSize, self.opaque, 0.0);
    }else{
        UIGraphicsBeginImageContext(imageSize);
    }
    
    // Render the view into the current graphics context
    /* iOS 7 */
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }else{ /* iOS 6 */
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    // Create an image from the current graphics context
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Clean up
    UIGraphicsEndImageContext();

    return image;
}
@end
