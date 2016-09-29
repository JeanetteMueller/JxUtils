//
//  JxPDF.h
//  AbaCloKPrototype
//
//  Created by Jeanette Müller on 26.09.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JxPDF : UIPrintPageRenderer

- (NSURL *)exportHTMLContent:(NSString *)html foPDF:(NSString *)filename;

@end
