//
//  UIView+RenderAsImage.swift
//  Podcat 2
//
//  Created by Jeanette Müller on 08.01.18.
//  Copyright © 2018 Jeanette Müller. All rights reserved.
//

import UIKit

extension UIView {
    
    func renderAsImage(fullScale scale: Bool = true) -> UIImage?{
        
        let imageSize = self.bounds.size
        
        // Create a graphics context with the target size
        if scale{
            UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
        }else{
            UIGraphicsBeginImageContext(imageSize)
        }
        
        
        if UIGraphicsGetCurrentContext() != nil {
            // Render the view into the current graphics context
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
            
            // Create an image from the current graphics context
            let image = UIGraphicsGetImageFromCurrentImageContext()
            
            // Clean up
            UIGraphicsEndImageContext()
            
            return image
        }
        return nil
    }
}

