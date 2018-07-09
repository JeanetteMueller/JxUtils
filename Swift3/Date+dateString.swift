//
//  Date+dateString.swift
//  projectPhoenix
//
//  Created by Jeanette Müller on 18.10.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import Foundation

class SharedDateFormatter {
    static let sharedDateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.locale = Locale.autoupdatingCurrent
        
        return formatter;
    }()
}

extension Date {
    
    func dateFormatedForHeadline() -> String{
        
        let formatter = SharedDateFormatter.sharedDateFormatter
        
        formatter.dateFormat = "MMMM yyyy"
        
        let formattedDateString = formatter.string(from: self)
        
        return formattedDateString
    }
}

extension NSDate {
    
    func dateFormatedForHeadline() -> String{
        
        let formatter = SharedDateFormatter.sharedDateFormatter
        
        formatter.dateFormat = "MMMM yyyy"
        
        let formattedDateString = formatter.string(from: self as Date)
        
        return formattedDateString
    }
}
