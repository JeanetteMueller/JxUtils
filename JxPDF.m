//
//  JxPDF.m
//  AbaCloKPrototype
//
//  Created by Jeanette Müller on 26.09.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

#import "JxPDF.h"

@implementation JxPDF

- (id)init {
    self = [super init];
    if (self) {
    
        //Specify the frame of the A4 page.
        CGFloat a4PageWidth = 595.2f;
        
        CGFloat a4PageHeight = 841.8f;
        
        CGRect paperRect = CGRectMake(0, 0, a4PageWidth, a4PageHeight);
        
        CGRect printableRect = CGRectInset(paperRect, 20, 20);
        
        [self setValue:[NSValue valueWithCGRect:paperRect] forKey:@"paperRect"];
        [self setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];
        
        
    }
    return self;
}

- (NSURL *)exportHTMLContent:(NSString *)html foPDF:(NSString *)filename{
    
    UIMarkupTextPrintFormatter *printFormatter = [[UIMarkupTextPrintFormatter alloc] initWithMarkupText:html];
    printFormatter.maximumContentWidth = self.printableRect.size.width-40;
    printFormatter.maximumContentHeight = self.printableRect.size.height-40;
    printFormatter.perPageContentInsets = UIEdgeInsetsMake(20, 20, 20, 20);
//    
//    printFormatter.startPage = 0;
    NSLog(@"printFormatter.pageCount %ld", (long)printFormatter.pageCount);
    
    [self addPrintFormatter:printFormatter startingAtPageAtIndex:0];
    
    [self prepareForDrawingPages:NSMakeRange(0, 7)];
    
    
    NSData *pdfData = [self drawPDF];
    
    NSString *filepath = [self filePathWithFilename:filename];
    if ([pdfData writeToFile:filepath atomically:YES]) {
        return [NSURL fileURLWithPath:filepath];
    }
    return nil;
}

- (NSData *)drawPDF{
    NSMutableData *data = [[NSMutableData alloc] init];
    
    UIGraphicsBeginPDFContextToData(data, CGRectZero, nil);
    
    NSLog(@"self.numberOfPages %ld", (long)self.numberOfPages);
    
    for (NSInteger p = 0; p < self.numberOfPages; p++) {
        
        UIGraphicsBeginPDFPage();
        
        CGRect bounds = UIGraphicsGetPDFContextBounds();
        
        [self drawPageAtIndex:p inRect:bounds];
    }
    
    
    UIGraphicsEndPDFContext();
    
    return data;
}

- (NSString *)filePathWithFilename:(NSString *)filename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *cachePath = [paths objectAtIndex:0];
    
    return [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf", filename]];
}

@end
