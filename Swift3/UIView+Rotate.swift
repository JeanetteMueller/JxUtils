//
//  UIView+Rotate.swift
//  Podcat 2
//
//  Created by Jeanette Müller on 16.01.19.
//  Copyright © 2019 Jeanette Müller. All rights reserved.
//

import UIKit

extension UIView {
    
    /**
     Rotate a view by specified degrees
     
     - parameter angle: angle in degrees
     */
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi

        self.transform = self.transform.rotated(by: radians)
    }
    
}
