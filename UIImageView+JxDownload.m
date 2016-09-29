//
//  UIImageView+Downloading.m
//  Podcat
//
//  Created by Jeanette Müller on 06.08.15.
//  Copyright (c) 2015 Jeanette Müller. All rights reserved.
//

#import "UIImageView+JxDownload.h"
#import "JxDownloadManager.h"
#import "JxFilesystem.h"
#import "JxImageCache.h"
#import "UIImage+Resize.h"

#import <CommonCrypto/CommonDigest.h>
#import <sys/stat.h>
#import <sys/xattr.h>
#import "NSString+MD5.h"
#import "UIImage+ImageEffects.h"
#import <objc/runtime.h>

@implementation UIImageView (JxDownload)

+ (NSString *)getImagePathForUrl:(NSString *)url{
    NSString *hash = [url MD5String];
    
    NSString *fileName = [hash stringByAppendingPathExtension:[url pathExtension]];
    
    return  [[JxDownloadManager sharedManager] localPathForFile:fileName inDirectory:@"images"];
}
- (void)downloadImageFromURL:(NSString *)url withFallbackImage:(UIImage *)fallback{
    
    [self downloadImageFromURL:url withFallbackImage:fallback withProgressBlock:self.progressBlock completionBlock:self.completionBlock];
}
- (void)downloadImageFromURL:(NSString *)url withFallbackImage:(UIImage *)fallback withProgressBlock:(void(^)(JxDownloadObject *download, CGFloat progress))block completionBlock:(void(^)(JxDownloadObject *download, BOOL completed))completionBlock{
    
    [self downloadImageFromURL:url withFallbackImage:fallback withProgressBlock:block completionBlock:completionBlock andCustomSize:CGSizeZero];
}
- (void)downloadImageFromURL:(NSString *)url withFallbackImage:(UIImage *)fallback withProgressBlock:(void(^)(JxDownloadObject *download, CGFloat progress))block completionBlock:(void(^)(JxDownloadObject *download, BOOL completed))completionBlock andCustomSize:(CGSize)customSize{
    
    NSString *hash = [url MD5String];
    
    NSString *fileName = [hash stringByAppendingPathExtension:[url pathExtension]];

    if ([[JxDownloadManager sharedManager] fileExistsWithName:fileName inDirectory:@"images"]) {
        
        JxDownloadObject *downloadObject = [[JxDownloadObject alloc] initWithDownloadTask:nil progressBlock:block remainingTime:nil completionBlock:completionBlock];
        downloadObject.startDate = [NSDate date];
        downloadObject.fileName = fileName;
        downloadObject.directoryName = @"images";
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            if (block) {
                block(downloadObject, 1.0f);
            }else{
                self.progressBlock(downloadObject, YES);
            }
            
            if (completionBlock) {
                completionBlock(downloadObject, YES);
            }else{
                self.completionBlock(downloadObject, YES);
            }
            
        });
        
        
        
    }else{
        if (fallback) {
            [self setImage:fallback];
        }
        
        [[JxDownloadManager sharedManager] downloadFileForURL:url
                                                      withName:[hash stringByAppendingPathExtension:[url pathExtension]]
                                              inDirectoryNamed:@"images"
                                                 progressBlock:block
                                               completionBlock:completionBlock
                                          enableBackgroundMode:YES];
        
        
        
    }
    
    
}
- (void)cancelDownloadFromURL:(NSString *)url{
    if ([[JxDownloadManager sharedManager] isFileDownloadingForUrl:url]) {
        //läuft schon
    }
}
- (UIImage *)resizeImageToViewSizeWithSourcePath:(NSString *)path andCustomSize:(CGSize)customSize andScale:(BOOL)useScale{
    
    if (CGSizeEqualToSize(customSize,CGSizeZero)) {
        customSize = self.frame.size;
    }
    
    CGFloat multiplier = 1.0;
    if (useScale) {
        multiplier = [UIScreen mainScreen].scale;
    }
    
    //DLog(@"customSize.width %f scale %f = %f", customSize.width, multiplier, customSize.width*multiplier);
    
    
    
    NSString *resizedPath = [UIImageView getPathForResizedPath:path withSize:customSize andScale:useScale];
    
    DLog(@"resizedPath %@", resizedPath);
    
    UIImage *image = [[JxImageCache sharedImageCache] cachedImageForRequest:[NSURL fileURLWithPath:resizedPath]];
    
    if (!image || ![image isKindOfClass:[UIImage class]]) {
        //DLog(@"load image vom storage");
        image = [UIImage imageWithContentsOfFile:resizedPath];
        
        if (!image) {
            //DLog(@"image with the right size not available-> create it");
            UIImage *original = [UIImage imageWithContentsOfFile:path];
            
            image = [original imageWithSize:CGSizeMake(customSize.width*multiplier, customSize.height*multiplier)];
            
            [UIImageJPEGRepresentation(image, 0.6) writeToFile:resizedPath atomically:YES];
            
        }else{
            //DLog(@"image with right size found and loaded");
        }
        
        if (image && [image isKindOfClass:[UIImage class]]) {
            [[JxImageCache sharedImageCache] cacheImage:image forRequest:[NSURL fileURLWithPath:resizedPath]];
        }
    }else{
        //DLog(@"image im cache");
    }
    
    if (image && [image isKindOfClass:[UIImage class]]) {
        
        return image;
    }
    
    return nil;
}

+ (NSString *)getPathForResizedPath:(NSString *)path withSize:(CGSize)size andScale:(BOOL)useScale {
    
    CGFloat multiplier = 1.0;
    if (useScale) {
        multiplier = [UIScreen mainScreen].scale;
    }
    
    NSString *extension = [path pathExtension];
    
    NSString *resizedPath = [path stringByDeletingPathExtension];
    resizedPath = [resizedPath stringByAppendingFormat:@"__resized__jpg__%dx%d", (int)(size.width*multiplier), (int)(size.height*multiplier)];
    resizedPath = [resizedPath stringByAppendingPathExtension:extension];
    
    resizedPath = [resizedPath stringByAppendingPathExtension:@"jpg"];
    return resizedPath;
}


- (JxDownloadProgressBlock)progressBlock {
    //__weak typeof(self)weakSelf = self;
    return ^void(JxDownloadObject *download, CGFloat progress){
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            //__strong __typeof(weakSelf)strongSelf = weakSelf;
            // do something with the progress on the cell!
            
            
        });
    };
}

- (JxDownloadCompletionBlock)completionBlock {
    __weak typeof(self)weakSelf = self;
    return ^void(JxDownloadObject *download, BOOL completed){
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            // do something
            
            if (completed) {
                
                NSString *path = [[JxDownloadManager sharedManager] localPathForFile:download.fileName inDirectory:download.directoryName];
                
                UIImage *resizedImage = [strongSelf resizeImageToViewSizeWithSourcePath:path andCustomSize:CGSizeZero andScale:NO];
                
                [strongSelf setImage:resizedImage];
            }
            
        });
    };
}
@end
