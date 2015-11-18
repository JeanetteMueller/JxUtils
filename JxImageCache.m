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
    static JxImageCache *sharedInstance = nil;
    static dispatch_once_t pred;
    
    if (sharedInstance) return sharedInstance;
    
    dispatch_once(&pred, ^{
        
        sharedInstance = [[JxImageCache alloc] init];
        sharedInstance.useCache = YES;
        
        
        [sharedInstance setCountLimit:50];
        [sharedInstance setTotalCostLimit:150000];
        [sharedInstance setEvictsObjectsWithDiscardedContent:YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(cleanUpMemory:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    });
    
    return sharedInstance;
}
- (UIImage *)cachedImageForRequest:(NSURL *)url {
    //DLog(@"url %@", url);
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

#pragma mark Notification
- (void)cleanUpMemory:(NSNotification *)notification{
    [self clearCache];
}
@end