#import <Foundation/Foundation.h>


@implementation UIImage (JxMasking)


- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
 
	CGImageRef maskRef = maskImage.CGImage; 
 
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
		CGImageGetHeight(maskRef),
		CGImageGetBitsPerComponent(maskRef),
		CGImageGetBitsPerPixel(maskRef),
		CGImageGetBytesPerRow(maskRef),
		CGImageGetDataProvider(maskRef), NULL, false);
 
	CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    CGImageRelease(mask);
    
    UIImage *newImage = [UIImage imageWithCGImage:masked];
    
    CGImageRelease(masked);
    
	return newImage;
 
}

@end