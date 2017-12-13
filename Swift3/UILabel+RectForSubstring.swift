//
//  UILabel+RectForSubstring.swift
//  projectPhoenix
//
//  Created by Jeanette Müller on 15.12.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit

extension UILabel {
    
    func rectForSubstring(withRange range:NSRange) -> CGRect?{
        
        guard let attributedText = attributedText else { return nil }
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(size:self.bounds.size)
        textContainer.lineFragmentPadding = 0;
        layoutManager.addTextContainer(textContainer)
        
        var glyphRange:NSRange = NSRange()
        
        layoutManager.characterRange(forGlyphRange:range, actualGlyphRange:&glyphRange)
        
        return layoutManager.boundingRect(forGlyphRange:glyphRange, in:textContainer)
        
    }
}
