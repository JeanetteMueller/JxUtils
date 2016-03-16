//
//  JxDownloadManager
//
//  Created by Jeanette Müller
//  Based on TWRDownloadManager by Michelangelo Chasseur.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class JxDownloadObject;

@interface JxDownloadManager : NSObject

@property (nonatomic, strong) void(^backgroundTransferCompletionHandler)();

+ (instancetype)sharedManager;

- (NSURLSessionDownloadTask *)downloadFileForURL:(NSString *)url
                                        withName:(NSString *)fileName
                                inDirectoryNamed:(NSString *)directory
                                   progressBlock:(void(^)(JxDownloadObject *download, CGFloat progress))progressBlock
                                 completionBlock:(void(^)(JxDownloadObject *download, BOOL completed))completionBlock
                            enableBackgroundMode:(BOOL)backgroundMode;

- (NSURLSessionDownloadTask *)downloadFileForURL:(NSString *)url
                                inDirectoryNamed:(NSString *)directory
                                   progressBlock:(void(^)(JxDownloadObject *download, CGFloat progress))progressBlock
                                 completionBlock:(void(^)(JxDownloadObject *download, BOOL completed))completionBlock
                            enableBackgroundMode:(BOOL)backgroundMode;

- (NSURLSessionDownloadTask *)downloadFileForURL:(NSString *)url
                                   progressBlock:(void(^)(JxDownloadObject *download, CGFloat progress))progressBlock
                                 completionBlock:(void(^)(JxDownloadObject *download, BOOL completed))completionBlock
                            enableBackgroundMode:(BOOL)backgroundMode;

#pragma mark - Download with estimated time

- (NSURLSessionDownloadTask *)downloadFileForURL:(NSString *)url
                                        withName:(NSString *)fileName
                                inDirectoryNamed:(NSString *)directory
                                   progressBlock:(void(^)(JxDownloadObject *download, CGFloat progress))progressBlock
                                   remainingTime:(void(^)(JxDownloadObject *download, NSUInteger seconds))remainingTimeBlock
                                 completionBlock:(void(^)(JxDownloadObject *download, BOOL completed))completionBlock
                            enableBackgroundMode:(BOOL)backgroundMode;

- (NSURLSessionDownloadTask *)downloadFileForURL:(NSString *)url
                                inDirectoryNamed:(NSString *)directory
                                   progressBlock:(void(^)(JxDownloadObject *download, CGFloat progress))progressBlock
                                   remainingTime:(void(^)(JxDownloadObject *download, NSUInteger seconds))remainingTimeBlock
                                 completionBlock:(void(^)(JxDownloadObject *download, BOOL completed))completionBlock
                            enableBackgroundMode:(BOOL)backgroundMode;

- (NSURLSessionDownloadTask *)downloadFileForURL:(NSString *)url
                                   progressBlock:(void(^)(JxDownloadObject *download, CGFloat progress))progressBlock
                                   remainingTime:(void(^)(JxDownloadObject *download, NSUInteger seconds))remainingTimeBlock
                                 completionBlock:(void(^)(JxDownloadObject *download, BOOL completed))completionBlock
                            enableBackgroundMode:(BOOL)backgroundMode;

- (void)cancelAllDownloads;
- (void)cancelDownloadForUrl:(NSString *)fileIdentifier;

- (BOOL)isFileDownloadingForUrl:(NSString *)url;

- (NSString *)localPathForFile:(NSString *)fileIdentifier;
- (NSString *)localPathForFile:(NSString *)fileIdentifier inDirectory:(NSString *)directoryName;

- (BOOL)fileExistsForUrl:(NSString *)urlString;
- (BOOL)fileExistsForUrl:(NSString *)urlString inDirectory:(NSString *)directoryName;
- (BOOL)fileExistsWithName:(NSString *)fileName;
- (BOOL)fileExistsWithName:(NSString *)fileName inDirectory:(NSString *)directoryName;

- (BOOL)deleteFileForUrl:(NSString *)urlString;
- (BOOL)deleteFileForUrl:(NSString *)urlString inDirectory:(NSString *)directoryName;
- (BOOL)deleteFileWithName:(NSString *)fileName;
- (BOOL)deleteFileWithName:(NSString *)fileName inDirectory:(NSString *)directoryName;

/**
 *  This method helps checking which downloads are currently ongoing.
 *
 *  @return an NSArray of NSString with the URLs of the currently downloading files.
 */
- (NSArray *)currentDownloads;

@end
