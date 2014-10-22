//
//  UILabel+RectForSubstring.m
//  Podcat
//
//  Created by Jeanette Müller on 20.10.14.
//  Copyright (c) 2014 Jeanette Müller. All rights reserved.
//

#import "UILabel+RectForSubstring.h"
#import <CoreText/CoreText.h>

@implementation UILabel (RectForSubstring)

- (CGRect)rectForSubstringWithRange:(NSRange)range{
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:[self attributedText]];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:[self bounds].size];
    textContainer.lineFragmentPadding = 0;
    [layoutManager addTextContainer:textContainer];
    
    NSRange glyphRange;
    
    // Convert the range for glyphs.
    [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];
    
    return [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];

}

@end
