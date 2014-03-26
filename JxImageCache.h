//
//  JxImageCache.h
//
//  Created by Jeanette Müller on 20.03.14.
//  MIT Licence
//

#import <Foundation/Foundation.h>


@interface JxImageCache : NSCache

@property (nonatomic, readwrite) BOOL useCache;

+ (JxImageCache *)sharedImageCache;
- (void)useImageCache:(BOOL)use;
- (UIImage *)cachedImageForRequest:(NSURL *)url;
- (void)cacheImage:(UIImage *)image forRequest:(NSURL *)url;
- (void)clearCache;

@end