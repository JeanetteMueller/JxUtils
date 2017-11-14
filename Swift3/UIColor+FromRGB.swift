//
//  UIColor+FromRGB.swift
//  Podcat 2
//
//  Created by Jeanette Müller on 14.11.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import UIKit

extension UIColor {
    
    // Helper function to convert from RGB to UIColor
    public static func fromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
