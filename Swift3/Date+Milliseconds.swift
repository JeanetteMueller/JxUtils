//
//  Date+Milliseconds.swift
//  HomeLCARS
//
//  Created by Jeanette Müller on 07.10.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import Foundation

extension Date {
    var millisecondsSince1970:Int {
        return Int(self.timeIntervalSince1970 * 1000.0)
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
