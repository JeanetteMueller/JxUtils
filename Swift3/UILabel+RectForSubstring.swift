//
//  UILabel+RectForSubstring.swift
//  projectPhoenix
//
//  Created by Jeanette Müller on 15.12.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit

extension UILabel {
    
    func rectForSubstring(withRange range:NSRange) -> CGRect{
        
        let textStorage = NSTextStorage.init(attributedString: self.attributedText!)
        
        let layoutManager = NSLayoutManager.init()
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer.init(size:self.bounds.size)
        textContainer.lineFragmentPadding = 0;
        layoutManager.addTextContainer(textContainer)
        
        var glyphRange:NSRange = NSRange.init()
        
        layoutManager.characterRange(forGlyphRange:range, actualGlyphRange:&glyphRange)
        
        return layoutManager.boundingRect(forGlyphRange:glyphRange, in:textContainer)
        
    }
}
