//
//  JxImageCache.m
//  Bikes1000
//
//  Created by Jeanette Müller on 20.03.14.
//  Copyright (c) 2014 Motorpresse Stuttgart. All rights reserved.
//

#import "JxImageCache.h"

@implementation JxImageCache

+ (JxImageCache *)sharedImageCache {
    static JxImageCache *_imageCache = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _imageCache = [[JxImageCache alloc] init];
        _imageCache.useCache = YES;
    });
    
    return _imageCache;
}
- (void)useImageCache:(BOOL)use{
    _useCache = use;
}
- (UIImage *)cachedImageForRequest:(NSURL *)url {
    
	return [self objectForKey:[url absoluteString]];
}
- (void)cacheImage:(UIImage *)image forRequest:(NSURL *)url{
    if (_useCache && image && url) {
        [self setObject:image forKey:[url absoluteString]];
    }
}
- (void)clearCache{
    [self removeAllObjects];
}
@end