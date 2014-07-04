//
//  NSArray+writeImagesToVideo.m
//  Podcat
//
//  Created by Jeanette Müller on 04.06.14.
//  Copyright (c) 2014 Jeanette Müller. All rights reserved.
//

#import "NSArray+writeImagesToVideo.h"
#import <AVFoundation/AVFoundation.h>

@implementation NSArray (writeImagesToVideo)

- (void)writeImagesAsVideoToFilePath:(NSString *)path mediaType:(NSString *)mediaFileType fps:(int)fps{
    
    if (fps == 0) {
        fps = 30;
    }
    
    UIImage *first = [self firstObject];
    
    
    CGSize frameSize = first.size;
    
    NSError *error = nil;
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:path]
                                                           fileType:mediaFileType
                                                              error:&error];
    
    if(error) {
        NSLog(@"error creating AssetWriter: %@",[error description]);
    }
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:frameSize.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:frameSize.height], AVVideoHeightKey,
                                   nil];
    
    
    
    AVAssetWriterInput* writerInput = [AVAssetWriterInput
                                        assetWriterInputWithMediaType:AVMediaTypeVideo
                                        outputSettings:videoSettings];
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32ARGB] forKey:(NSString*)kCVPixelBufferPixelFormatTypeKey];
    [attributes setObject:[NSNumber numberWithUnsignedInt:frameSize.width] forKey:(NSString*)kCVPixelBufferWidthKey];
    [attributes setObject:[NSNumber numberWithUnsignedInt:frameSize.height] forKey:(NSString*)kCVPixelBufferHeightKey];
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput
                                                                                                                     sourcePixelBufferAttributes:attributes];
    
    [videoWriter addInput:writerInput];
    
    // fixes all errors
    writerInput.expectsMediaDataInRealTime = YES;
    
    //Start a session:
    [videoWriter startWriting];
    
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    CVPixelBufferRef buffer = NULL;
    buffer = [self pixelBufferFromCGImage:[first CGImage]];
    BOOL result = [adaptor appendPixelBuffer:buffer withPresentationTime:kCMTimeZero];
    
    if (result == NO) //failes on 3GS, but works on iphone 4
        NSLog(@"failed to append buffer");
    
    if(buffer) {
        CVBufferRelease(buffer);
    }
    

    int i = 0;
    for (UIImage *imgFrame in self)
    {
        if (adaptor.assetWriterInput.readyForMoreMediaData) {
            
            i++;
            CMTime frameTime = CMTimeMake(1, fps);
            CMTime lastTime = CMTimeMake(i, fps);
            CMTime presentTime = CMTimeAdd(lastTime, frameTime);
            


            buffer = [self pixelBufferFromCGImage:[imgFrame CGImage]];
            BOOL result = [adaptor appendPixelBuffer:buffer withPresentationTime:presentTime];
            
            if (result == NO){ //failes on 3GS, but works on iphone 4
                NSLog(@"failed to append buffer");
                NSLog(@"The error is %@", [videoWriter error]);
            }else{
                NSLog(@"--- inserted %d", i);
            }
            
            if(buffer) {
                CVBufferRelease(buffer);
            }
            
            [NSThread sleepForTimeInterval:0.02f];
            
        } else {
            NSLog(@"error");
            i--;
        }
        
        
    }
    
    //Finish the session:
    [writerInput markAsFinished];
    [videoWriter finishWriting];
    CVPixelBufferPoolRelease(adaptor.pixelBufferPool);

    
    NSLog(@"Movie created successfully");
    
    
}

- (CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    
    CVPixelBufferCreate(kCFAllocatorDefault, CGImageGetWidth(image),
                        CGImageGetHeight(image), kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                        &pxbuffer);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, CGImageGetWidth(image),
                                                 CGImageGetHeight(image), 8, 4*CGImageGetWidth(image), rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
    
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
    
    //    CGAffineTransform flipVertical = CGAffineTransformMake(
    //                                                           1, 0, 0, -1, 0, CGImageGetHeight(image)
    //                                                           );
    //    CGContextConcatCTM(context, flipVertical);
    
    
    
    //    CGAffineTransform flipHorizontal = CGAffineTransformMake(
    //                                                             -1.0, 0.0, 0.0, 1.0, CGImageGetWidth(image), 0.0
    //                                                             );
    //
    //    CGContextConcatCTM(context, flipHorizontal);
    
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}
@end
