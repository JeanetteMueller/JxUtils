//
//  UIColor+hexstring.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 04.11.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit

extension UIColor{
    
    class func colorFromHex(_ hex:String) -> UIColor {
        return UIColor.fromHexstring(hex: hex)
    }
    class func fromHexstring(hex:String) -> UIColor {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.characters.count != 6 && cString.characters.count != 8) {
            return UIColor.red
        }
        

        if cString.characters.count == 6{
            cString.append("FF")
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
        let green = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
        let blue = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
        
        let alpha = CGFloat(rgbValue & 0x000000FF) / 255.0
        
        //print("color", hex, red, alpha)
        
        return UIColor(
            red: red,
            green: green,
            blue: blue,
            alpha: alpha
        )
    }
}
