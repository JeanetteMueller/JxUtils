//
//  Date+StarDate.swift
//  HomeLCARS
//
//  Created by Jeanette Müller on 06.10.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import Foundation

extension Date {
    
    func starDate(decimals:Int = 2, prefixSDDisplay:Bool = false) -> String{
        
        let cal = Calendar.current
        
        let timeNow = self
        
        var timeNowMilli = timeNow.millisecondsSince1970
        
//        // UTC correction
        let offsetTime = Double(cal.timeZone.secondsFromGMT(for: timeNow)) / 3600.0
        let diffUTCTime = Int(offsetTime * 60000)
        timeNowMilli = timeNowMilli + diffUTCTime
        
        // ** Common **
        // millsecInQCYear is the number of milliseconds in
        // a standard quadcent year.
        let millisecInQCYear = 31556952000
        
        // ** TNG style SD **
        
        // prefixSDTNGZero is the starting prefix for TNG style
        // stardates, which is [21] 00000.00.
        let prefixSDTNGZero:Double = 21
        
        // timeSDTNGZero is the date when the TNG style stardates
        // begin, january 1st, 2323. It is a date coinciding in
        // both quadcent and gregorian calendars.
        
        var nowComponents = cal.dateComponents([.year, .month, .day], from: timeNow)
        nowComponents.year = 2323
        nowComponents.month = 1
        nowComponents.day = 1
        
        let timeSDTNGZero = cal.date(from: nowComponents)! //Date(2323,0,1)
        let timeSDTNGZeroMilli = timeSDTNGZero.millisecondsSince1970
        
        // Compute the time difference between reference and now.
        let timeBetweenTNG = timeNowMilli - (timeSDTNGZeroMilli + Int((3600 * 1000) * offsetTime))
        
        // rawSDTNG is not really a SD since it's prefix and SD
        // difference concatenated. The formula is simple:
        // 1000 SD units == 1 quadcent year,
        // 1 quadcentyear == 31556952 seconds,
        // so SD value for the difference is:
        let rawSDTNG = Double(timeBetweenTNG * 1000) / Double(millisecInQCYear)
        
        // refinedSDTNG is the real SD value.
        // As rawSDTNG is a difference, if rawSDTNG is positive
        // the real SD value is the modulo , if rawSDTNG is
        // negative, 100000 is added to the modulo, as rawSDTNG is a
        // difference (and is the complement to 100000 of
        // the real SD).
        
        var refinedSDTNG:Double = rawSDTNG.truncatingRemainder(dividingBy: 100000)
        
        if (rawSDTNG < 0){
            refinedSDTNG = 100000 + refinedSDTNG
        }
        
        //let displaySDTNG = roundf(1000.0 * Float(refinedSDTNG)) / 1000.0
        
        let format = String(format: "%%.%df", decimals)
        
        let displaySDTNGString = String.init(format: format, refinedSDTNG)
        
        // diffPrefixSDTNG is the difference in the SD prefix.
        let diffPrefixSDTNG = floor(Double(rawSDTNG) / 100000)
        
        // The real SD prefix.
        let prefixSDTNG = prefixSDTNGZero + diffPrefixSDTNG
        
        // The SD string.
        if (prefixSDDisplay == true){
            
            let starDate = String(format: "[%.0f] %@", prefixSDTNG, displaySDTNGString)
            
            return starDate
        }else{
            return displaySDTNGString
        }
    }
}

