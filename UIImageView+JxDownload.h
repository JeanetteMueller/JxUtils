//
//  UIImageView+Downloading.h
//  Podcat
//
//  Created by Jeanette Müller on 06.08.15.
//  Copyright (c) 2015 Jeanette Müller. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JxDownloadObject;

@interface UIImageView (JxDownload)

+ (NSString *)getImagePathForUrl:(NSString *)url;

- (void)downloadImageFromURL:(NSString *)imageUrl withFallbackImage:(UIImage *)fallback;
- (void)downloadImageFromURL:(NSString *)url withFallbackImage:(UIImage *)fallback withProgressBlock:(void(^)(JxDownloadObject *download, CGFloat progress))block completionBlock:(void(^)(JxDownloadObject *download, BOOL completed))completionBlock;
- (void)downloadImageFromURL:(NSString *)url withFallbackImage:(UIImage *)fallback withProgressBlock:(void(^)(JxDownloadObject *download, CGFloat progress))block completionBlock:(void(^)(JxDownloadObject *download, BOOL completed))completionBlock andCustomSize:(CGSize)customSize;

- (void)cancelDownloadFromURL:(NSString *)url;

- (UIImage *)resizeImageToViewSizeWithSourcePath:(NSString *)path andCustomSize:(CGSize)customSize andScale:(BOOL)useScale andBlur:(BOOL)blur;

+ (NSString *)getPathForResizedPath:(NSString *)path withSize:(CGSize)size andScale:(BOOL)useScale andBlur:(BOOL)blur;

@end
