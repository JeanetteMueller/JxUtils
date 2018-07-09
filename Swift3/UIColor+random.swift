//
//  UIColor+random.swift
//  HomeLCARS
//
//  Created by Jeanette Müller on 29.01.18.
//  Copyright © 2018 Jeanette Müller. All rights reserved.
//

import UIKit

extension UIColor {
    
    open class var random: UIColor {
        get{
            
            return UIColor(red:   .random(),
                           green: .random(),
                           blue:  .random(),
                           alpha: 1.0)
            
        }
    }
    
    open class var randomGrayscale: UIColor {
        get{
            
            let r = CGFloat.random()
            
            return UIColor(red:   r,
                           green: r,
                           blue:  r,
                           alpha: 1.0)
            
        }
    }
}
