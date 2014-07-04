//
//  NSArray+writeImagesToVideo.h
//  Podcat
//
//  Created by Jeanette Müller on 04.06.14.
//  Copyright (c) 2014 Jeanette Müller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (writeImagesToVideo)

- (void)writeImagesAsVideoToFilePath:(NSString *)path mediaType:(NSString *)mediaFileType fps:(int)fps;

@end
