//
//  UILabel+RectForSubstring.h
//  Podcat
//
//  Created by Jeanette Müller on 20.10.14.
//  Copyright (c) 2014 Jeanette Müller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (RectForSubstring)

- (CGRect)rectForSubstringWithRange:(NSRange)range;

@end
