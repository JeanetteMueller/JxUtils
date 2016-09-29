//
//  JxDownloadManager
//
//  Created by Jeanette Müller
//  Based on TWRDownloadManager by Michelangelo Chasseur.
//

#import "JxDownloadManager.h"
#import "JxDownloadObject.h"
#import "NSString+MD5.h"


@interface JxDownloadManager () <NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSession *backgroundSession;
@property (strong, nonatomic) NSMutableDictionary *downloads;

@end

@implementation JxDownloadManager

+ (instancetype)sharedManager {
    static JxDownloadManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[JxDownloadManager alloc] init];
    });
    
    return _sharedManager;
}
- (NSString *)getUserAgent{
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@.%@ (%@; %@; %@ %@)",
                           [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleName"],
                           [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"],
                           [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"],
                           [UIDevice currentDevice].model,
                           [[[NSUserDefaults standardUserDefaults] objectForKey: @"AppleLanguages"] objectAtIndex:0],
                           [UIDevice currentDevice].systemName,
                           [UIDevice currentDevice].systemVersion];
    
    return userAgent;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        // Default session
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        if ([UIDevice class]) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
                configuration.timeoutIntervalForRequest = 60;
            }
        }
        
        configuration.HTTPAdditionalHeaders = @{@"User-Agent": [self getUserAgent]};
        
        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];

        // Background session
        NSURLSessionConfiguration *backgroundConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"re.touchwa.downloadmanager"];
        
        backgroundConfiguration.HTTPAdditionalHeaders = @{@"User-Agent": [self getUserAgent]};
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            backgroundConfiguration.timeoutIntervalForRequest = 60.0;
        }
        
        
        
        self.backgroundSession = [NSURLSession sessionWithConfiguration:backgroundConfiguration delegate:self delegateQueue:nil];
        
        self.downloads = [NSMutableDictionary new];
    }
    return self;
}

#pragma mark - Downloading... 
- (NSString *)getFileNameFromString:(NSString *)string{
    
    NSString *fileName = [string lastPathComponent];
    
    if (!fileName) {
        fileName = [string MD5String];
    }
    return fileName;
    
}
- (NSURLSessionDownloadTask *)downloadFileForURL:(NSString *)urlString
                  withName:(NSString *)fileName
          inDirectoryNamed:(NSString *)directory
             progressBlock:(void(^)(JxDownloadObject *download, CGFloat progress))progressBlock
             remainingTime:(void(^)(JxDownloadObject *download, NSUInteger seconds))remainingTimeBlock
           completionBlock:(void(^)(JxDownloadObject *download, BOOL completed))completionBlock
      enableBackgroundMode:(BOOL)backgroundMode {
    NSURL *url = [NSURL URLWithString:urlString];
    if (!fileName) {
        fileName = [self getFileNameFromString:urlString];
    }
    
    if (![self fileDownloadCompletedForUrl:urlString]) {
        DLog(@"File is downloading!");
        
        JxDownloadObject *download = [self.downloads objectForKey:urlString];
        
        if (progressBlock) {
            [download.progressBlocks addObject:progressBlock];
        }
        if (remainingTimeBlock) {
            [download.remainingTimeBlocks addObject:remainingTimeBlock];
        }
        if (completionBlock) {
            [download.completionBlocks addObject:completionBlock];
        }
        
    } else if (![self fileExistsWithName:fileName inDirectory:directory]) {

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            request.timeoutInterval = 60.0;
        }
        
        NSURLSessionDownloadTask *downloadTask;
        if (backgroundMode) {
            downloadTask = [self.backgroundSession downloadTaskWithRequest:request];
        } else {
            downloadTask = [self.session downloadTaskWithRequest:request];
        }
        
        downloadTask.taskDescription = [NSString stringWithFormat:@"%@||#||%@", fileName, directory];
        
        JxDownloadObject *downloadObject = [[JxDownloadObject alloc] initWithDownloadTask:downloadTask
                                                                            progressBlock:progressBlock
                                                                            remainingTime:remainingTimeBlock
                                                                          completionBlock:completionBlock];
        
        downloadObject.startDate = [NSDate new];
        downloadObject.fileName = fileName;
        downloadObject.directoryName = directory;
        if (urlString && downloadObject) {
            [self.downloads addEntriesFromDictionary:@{urlString:downloadObject}];
            [downloadTask resume];
            DLog(@"File download started");
            return downloadTask;

        }else{
            DLog(@"Download fehlgeschlagen");
        }
    } else {
        DLog(@"File already exists!");
    }
    
    return nil;
}

- (NSURLSessionDownloadTask *)downloadFileForURL:(NSString *)url
          inDirectoryNamed:(NSString *)directory
             progressBlock:(void(^)(JxDownloadObject *download, CGFloat progress))progressBlock
             remainingTime:(void(^)(JxDownloadObject *download, NSUInteger seconds))remainingTimeBlock
           completionBlock:(void(^)(JxDownloadObject *download, BOOL completed))completionBlock
      enableBackgroundMode:(BOOL)backgroundMode {
    return [self downloadFileForURL:url
                    withName:[self getFileNameFromString:url]
            inDirectoryNamed:directory
               progressBlock:progressBlock
               remainingTime:remainingTimeBlock
             completionBlock:completionBlock
        enableBackgroundMode:backgroundMode];
}

- (NSURLSessionDownloadTask *)downloadFileForURL:(NSString *)url
             progressBlock:(void(^)(JxDownloadObject *download, CGFloat progress))progressBlock
             remainingTime:(void(^)(JxDownloadObject *download, NSUInteger seconds))remainingTimeBlock
           completionBlock:(void(^)(JxDownloadObject *download, BOOL completed))completionBlock
      enableBackgroundMode:(BOOL)backgroundMode {
    return [self downloadFileForURL:url
                    withName:[self getFileNameFromString:url]
            inDirectoryNamed:nil
               progressBlock:progressBlock
               remainingTime:remainingTimeBlock
             completionBlock:completionBlock
        enableBackgroundMode:backgroundMode];
}

- (NSURLSessionDownloadTask *)downloadFileForURL:(NSString *)urlString
                  withName:(NSString *)fileName
          inDirectoryNamed:(NSString *)directory
             progressBlock:(void(^)(JxDownloadObject *download, CGFloat progress))progressBlock
           completionBlock:(void(^)(JxDownloadObject *download, BOOL completed))completionBlock
      enableBackgroundMode:(BOOL)backgroundMode {
    return [self downloadFileForURL:urlString
                   withName:fileName
           inDirectoryNamed:directory
              progressBlock:progressBlock
              remainingTime:nil
            completionBlock:completionBlock
        enableBackgroundMode:backgroundMode];
}

- (NSURLSessionDownloadTask *)downloadFileForURL:(NSString *)urlString
          inDirectoryNamed:(NSString *)directory
             progressBlock:(void(^)(JxDownloadObject *download, CGFloat progress))progressBlock
           completionBlock:(void(^)(JxDownloadObject *download, BOOL completed))completionBlock
      enableBackgroundMode:(BOOL)backgroundMode {
    // if no file name was provided, use the last path component of the URL as its name
    return [self downloadFileForURL:urlString
                    withName:[self getFileNameFromString:urlString]
            inDirectoryNamed:directory
               progressBlock:progressBlock
             completionBlock:completionBlock
        enableBackgroundMode:backgroundMode];
}

- (NSURLSessionDownloadTask *)downloadFileForURL:(NSString *)urlString
             progressBlock:(void(^)(JxDownloadObject *download, CGFloat progress))progressBlock
           completionBlock:(void(^)(JxDownloadObject *download, BOOL completed))completionBlock
      enableBackgroundMode:(BOOL)backgroundMode {
    return [self downloadFileForURL:urlString
            inDirectoryNamed:nil
               progressBlock:progressBlock
             completionBlock:completionBlock
        enableBackgroundMode:backgroundMode];
}

- (void)removeAllBlocks{
    LLog();
    for (JxDownloadObject *download in self.downloads.allValues) {
        if (![download.directoryName isEqualToString:kDownloadDirectorysFeeds] &&
            ![download.directoryName isEqualToString:kDownloadDirectorysDirectory] &&
            ![download.directoryName isEqualToString:kDownloadDirectorysImages]) {
            
            [download.completionBlocks removeAllObjects];
            [download.remainingTimeBlocks removeAllObjects];
            [download.progressBlocks removeAllObjects];
        }
    }
}
- (void)cancelDownloadForUrl:(NSString *)fileIdentifier {
    LLog();
    JxDownloadObject *download = [self.downloads objectForKey:fileIdentifier];
    if (download) {
        [download.downloadTask cancel];
        [self.downloads removeObjectForKey:fileIdentifier];
        if (download.completionBlocks.count > 0) {
            for (JxDownloadCompletionBlock block in download.completionBlocks.copy) {
                block(download, NO);
            }
        }
    }
    if (self.downloads.count == 0) {
        [self cleanTmpDirectory];
        
    }
}

- (void)cancelAllDownloads {
    LLog();
    [self.downloads enumerateKeysAndObjectsUsingBlock:^(id key, JxDownloadObject *download, BOOL *stop) {
        [download.downloadTask cancel];
        [self.downloads removeObjectForKey:key];
        
        if (download.completionBlocks.count > 0) {
            for (JxDownloadCompletionBlock block in download.completionBlocks.copy) {
                block(download, NO);
            }
        }
    }];
    [self cleanTmpDirectory];
}

- (NSArray <JxDownloadObject *> *)currentDownloads {
    NSMutableArray *currentDownloads = [NSMutableArray new];
    [self.downloads enumerateKeysAndObjectsUsingBlock:^(id key, JxDownloadObject *download, BOOL *stop) {
        
        if (download.downloadTask.originalRequest.URL.absoluteString) {
            
            if (download.downloadTask.state != NSURLSessionTaskStateCompleted) {
                
                [currentDownloads addObject:download];
            }
            
        }
    }];
    return currentDownloads;
}

#pragma mark - NSURLSession Delegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error{
    DLog(@"error %@ -> %@", error, error.localizedDescription);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler{
    LLog();
}
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    LLog();
    
    NSString *fileIdentifier = downloadTask.originalRequest.URL.absoluteString;
    JxDownloadObject *download = [self.downloads objectForKey:fileIdentifier];
    
    CGFloat newprogress = (CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite;
    
    if (download.progress < newprogress - 0.005f) {
        download.progress = newprogress;
        
        if (download.progressBlocks.count > 0) {
            
            for (JxDownloadProgressBlock block in download.progressBlocks.copy) {
                block(download, download.progress);
            }
            
            
        }
        
        CGFloat remainingTime = [self remainingTimeForDownload:download bytesTransferred:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
        if (download.remainingTimeBlocks.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                for (JxDownloadRemainingTimeBlock block in download.remainingTimeBlocks.copy) {
                    block(download, (NSUInteger)remainingTime);
                }
            });
        }
    }
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    LLog();
    NSError *error;
    NSURL *destinationLocation;
    
    NSString *fileIdentifier = downloadTask.originalRequest.URL.absoluteString;
    JxDownloadObject *download = [self.downloads objectForKey:fileIdentifier];
    
    if (!download) {
        
        NSArray *parts = [downloadTask.taskDescription componentsSeparatedByString:@"||#||"];
        if (parts.count > 0) {
            download = [[JxDownloadObject alloc] initWithDownloadTask:downloadTask progressBlock:nil remainingTime:nil completionBlock:nil];
            download.fileName = parts[0];
            download.directoryName = parts[1];
            
            [self.downloads setObject:download forKey:fileIdentifier];
        }
        
    }
    
    if (download) {
        
        if (downloadTask.error) {
            DLog(@"task %@ didFinishDownloadingToURL with error %@", downloadTask, downloadTask.error);
        }
        
        
        if (download.directoryName) {
            destinationLocation = [[[self cachesDirectoryUrlPath] URLByAppendingPathComponent:download.directoryName] URLByAppendingPathComponent:download.fileName];
        } else {
            destinationLocation = [[self cachesDirectoryUrlPath] URLByAppendingPathComponent:download.fileName];
        }
        
        // Move downloaded item from tmp directory to te caches directory
        // (not synced with user's iCloud documents)
        [[NSFileManager defaultManager] moveItemAtURL:location
                                                toURL:destinationLocation
                                                error:&error];
        if (error) {
            DLog(@"ERROR: %@", error);
        }
        
        // remove object from the download
        [self.downloads removeObjectForKey:fileIdentifier];
        
        if (download.completionBlocks.count > 0) {
            for (JxDownloadCompletionBlock block in download.completionBlocks.copy) {
                if ([(NSHTTPURLResponse *)downloadTask.response statusCode] >= 400 && [(NSHTTPURLResponse *)downloadTask.response statusCode] < 500) {
                    block(download, NO);
                }else{
                    block(download, YES);
                }
            }
        }
    }
}

- (CGFloat)remainingTimeForDownload:(JxDownloadObject *)download
                   bytesTransferred:(int64_t)bytesTransferred
          totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:download.startDate];
    CGFloat speed = (CGFloat)bytesTransferred / (CGFloat)timeInterval;
    CGFloat remainingBytes = totalBytesExpectedToWrite - bytesTransferred;
    CGFloat remainingTime =  remainingBytes / speed;
    return remainingTime;
}

#pragma mark - File Management

- (NSURL *)cachesDirectoryUrlPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSURL *cachesDirectoryUrl = [NSURL fileURLWithPath:cachesDirectory];
    return cachesDirectoryUrl;
}

- (BOOL)fileDownloadCompletedForUrl:(NSString *)fileIdentifier {
    BOOL retValue = YES;
    JxDownloadObject *download = [self.downloads objectForKey:fileIdentifier];
    if (download && download.downloadTask.state != NSURLSessionTaskStateCompleted) {
        // downloads are removed once they finish
        retValue = NO;
    }
    return retValue;
}

- (BOOL)isFileDownloadingForUrl:(NSString *)fileIdentifier{
    BOOL retValue = NO;
    if (self.downloads.allKeys.count > 0) {
        JxDownloadObject *download = [self.downloads objectForKey:fileIdentifier];
        if (download && download.downloadTask.state != NSURLSessionTaskStateCompleted) {
            retValue = YES;
        }
    }
    
    return retValue;
}

#pragma mark File existance

- (NSString *)localPathForFile:(NSString *)fileIdentifier {
    return [self localPathForFile:fileIdentifier inDirectory:nil];
}

- (NSString *)localPathForFile:(NSString *)fileIdentifier inDirectory:(NSString *)directoryName {
    NSString *fileName = [self getFileNameFromString:fileIdentifier];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    return [[cachesDirectory stringByAppendingPathComponent:directoryName] stringByAppendingPathComponent:fileName];
}

- (BOOL)fileExistsForUrl:(NSString *)urlString {
    return [self fileExistsForUrl:urlString inDirectory:nil];
}

- (BOOL)fileExistsForUrl:(NSString *)urlString inDirectory:(NSString *)directoryName {
    return [self fileExistsWithName:[self getFileNameFromString:urlString] inDirectory:directoryName];
}

- (BOOL)fileExistsWithName:(NSString *)fileName
               inDirectory:(NSString *)directoryName {
    BOOL exists = NO;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    
    // if no directory was provided, we look by default in the base cached dir
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[cachesDirectory stringByAppendingPathComponent:directoryName] stringByAppendingPathComponent:fileName]]) {
        exists = YES;
    }
    
    return exists;
}

- (BOOL)fileExistsWithName:(NSString *)fileName {
    return [self fileExistsWithName:fileName inDirectory:nil];
}

#pragma mark File deletion

- (BOOL)deleteFileForUrl:(NSString *)urlString {
    return [self deleteFileForUrl:urlString inDirectory:nil];
}

- (BOOL)deleteFileForUrl:(NSString *)urlString inDirectory:(NSString *)directoryName {
    return [self deleteFileWithName:[self getFileNameFromString:urlString] inDirectory:directoryName];
}

- (BOOL)deleteFileWithName:(NSString *)fileName {
    return [self deleteFileWithName:fileName inDirectory:nil];
}

- (BOOL)deleteFileWithName:(NSString *)fileName
               inDirectory:(NSString *)directoryName {
    BOOL deleted = NO;
    
    NSError *error;
    NSURL *fileLocation;
    if (directoryName) {
        fileLocation = [[[self cachesDirectoryUrlPath] URLByAppendingPathComponent:directoryName] URLByAppendingPathComponent:fileName];
    } else {
        fileLocation = [[self cachesDirectoryUrlPath] URLByAppendingPathComponent:fileName];
    }
    
    
    // Move downloaded item from tmp directory to te caches directory
    // (not synced with user's iCloud documents)
    [[NSFileManager defaultManager] removeItemAtURL:fileLocation error:&error];
    
    if (error) {
        deleted = NO;
        DLog(@"Error deleting file: %@", error);
    } else {
        deleted = YES;
    }
    return deleted;
}

#pragma mark - Clean tmp directory

- (void)cleanTmpDirectory {
    NSArray* tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
    for (NSString *file in tmpDirectory) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
    }
}

#pragma mark - Background download

-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    // Check if all download tasks have been finished.
    [session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        if ([downloadTasks count] == 0) {
            if (self.backgroundTransferCompletionHandler != nil) {
                // Copy locally the completion handler.
                void(^completionHandler)() = self.backgroundTransferCompletionHandler;
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // Call the completion handler to tell the system that there are no other background transfers.
                    completionHandler();
                    
//                    // Show a local notification when all downloads are over.
//                    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//                    localNotification.alertBody = @"All files have been downloaded!";
//                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                }];
                
                // Make nil the backgroundTransferCompletionHandler.
                self.backgroundTransferCompletionHandler = nil;
            }
        }
    }];
}

@end
