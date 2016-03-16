//
//  JxDownloadManager
//
//  Created by Jeanette Müller
//  Based on TWRDownloadManager by Michelangelo Chasseur.
//

#import "JxDownloadObject.h"

@implementation JxDownloadObject

- (instancetype)initWithDownloadTask:(NSURLSessionDownloadTask *)downloadTask
                       progressBlock:(JxDownloadProgressBlock)progressBlock
                       remainingTime:(JxDownloadRemainingTimeBlock)remainingTimeBlock
                     completionBlock:(JxDownloadCompletionBlock)completionBlock {
    self = [super init];
    if (self) {
        self.downloadTask = downloadTask;
        
        self.progressBlocks = [NSMutableArray array];
        self.remainingTimeBlocks = [NSMutableArray array];
        self.completionBlocks = [NSMutableArray array];
        
        if (progressBlock) {
            [self.progressBlocks addObject:progressBlock];
        }
        if (remainingTimeBlock) {
            [self.remainingTimeBlocks addObject:remainingTimeBlock];
        }
        if (completionBlock) {
            [self.completionBlocks addObject:completionBlock];
        }
    }
    return self;
}

@end
