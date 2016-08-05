//
//  JxDownloadManager
//
//  Created by Jeanette Müller
//  Based on TWRDownloadManager by Michelangelo Chasseur.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class JxDownloadObject;

typedef void(^JxDownloadRemainingTimeBlock)(JxDownloadObject *download, NSUInteger seconds);
typedef void(^JxDownloadProgressBlock)(JxDownloadObject *download, CGFloat progress);
typedef void(^JxDownloadCompletionBlock)(JxDownloadObject *download, BOOL completed);

@interface JxDownloadObject : NSObject

@property (strong, nonatomic) NSMutableArray <JxDownloadProgressBlock> *progressBlocks;
@property (strong, nonatomic) NSMutableArray <JxDownloadCompletionBlock> *completionBlocks;
@property (strong, nonatomic) NSMutableArray <JxDownloadRemainingTimeBlock> *remainingTimeBlocks;

@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (copy, nonatomic) NSString *fileName;
@property (copy, nonatomic) NSString *directoryName;
@property (copy, nonatomic) NSDate *startDate;
@property (assign, nonatomic) CGFloat progress;

- (instancetype)initWithDownloadTask:(NSURLSessionDownloadTask *)downloadTask
                       progressBlock:(JxDownloadProgressBlock)progressBlock
                       remainingTime:(JxDownloadRemainingTimeBlock)remainingTimeBlock
                     completionBlock:(JxDownloadCompletionBlock)completionBlock;

@end
