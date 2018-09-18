//
//  String+RegEx.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 20.02.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import Foundation

extension String {
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map { result.range(at: $0).location != NSNotFound
                ? nsString.substring(with: result.range(at: $0))
                : ""
            }
        }
    }
    var length: Int {
        return self.count
    }
    
    subscript(_ i: Int) -> String {
        let idx1 = index(startIndex, offsetBy: i)
        let idx2 = index(idx1, offsetBy: 1)
        return String(self[idx1..<idx2])
    }
    
    func substring(from: Int) -> String {
        
        let idx1 = min(from, length)
        let idx2 = length
        
        return String(self[idx1..<idx2])
    }
    
    func substring(to: Int) -> String {
        
        let idx1 = 0
        let idx2 = max(0, to)
        
        return String(self[idx1 ..< idx2])
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        
        let stringRange: Range<String.Index> = start..<end
        
        return String(self[stringRange])
    }
}
