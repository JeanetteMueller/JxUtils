//
//  Math.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 22.11.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import Foundation
import UIKit

class Math {
    
    class func roundToTens(x : CGFloat) -> CGFloat {
        return CGFloat(10 * Int(round(x / 10.0)))
    }
    class func ceilToTens(x : CGFloat) -> CGFloat {
        return CGFloat(10 * Int(ceil(x / 10.0)))
    }
    
    class func doubleFromString(_ string:String?) -> Double{
        
        var value:Double = 0;
        if let s = string{
            let startParts = s.components(separatedBy: ":")
            var step = 0;
            
            for part in startParts.reversed() {
                switch (step) {
                case 2:
                    value = value + ((part as NSString).doubleValue * 60 * 60)
                    break;
                case 1:
                    value = value + ((part as NSString).doubleValue * 60)
                    break;
                default:
                    value = value + (part as NSString).doubleValue
                    break;
                }
                
                step = step + 1
            }

            
            
        }
        return value
    }
}
