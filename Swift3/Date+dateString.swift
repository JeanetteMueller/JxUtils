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
    
    func dateString() -> String{
        
        let formatter = SharedDateFormatter.sharedDateFormatter
        
        formatter.dateFormat = "MMMM yyyy"
        
        let formattedDateString = formatter.string(from: self)
        
        //NSLog(@"formattedDateString for locale %@: %@", [[formatter locale] localeIdentifier], formattedDateString);
        
        //NSLog(@"formattedDateString: %@", formattedDateString);
        
        return formattedDateString
    }
}

extension NSDate {
    
    func dateString() -> String{
        
        let formatter = SharedDateFormatter.sharedDateFormatter
        
        formatter.dateFormat = "MMMM yyyy"
        
        let formattedDateString = formatter.string(from: self as Date)
        
        //NSLog(@"formattedDateString for locale %@: %@", [[formatter locale] localeIdentifier], formattedDateString);
        
        //NSLog(@"formattedDateString: %@", formattedDateString);
        
        return formattedDateString
    }
}
