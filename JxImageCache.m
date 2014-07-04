//
//  JxImageCache.m
//
//  Created by Jeanette Müller on 20.03.14.
//  MIT Licence
//

#import "JxImageCache.h"
#import "Logging.h"

@implementation JxImageCache

+ (JxImageCache *)sharedImageCache {
    static JxImageCache *_imageCache = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _imageCache = [[JxImageCache alloc] init];
        _imageCache.useCache = YES;
        
        
        [_imageCache setCountLimit:50];
        [_imageCache setTotalCostLimit:150000];
        [_imageCache setEvictsObjectsWithDiscardedContent:YES];
        
        
    });
    
    return _imageCache;
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