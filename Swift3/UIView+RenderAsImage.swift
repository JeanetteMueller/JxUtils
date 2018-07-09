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
            UIGraphicsBeginImageContextWithOptions(imageSize, true, 0.0)
        }else{
            UIGraphicsBeginImageContext(imageSize)
        }
        
        
        if let context = UIGraphicsGetCurrentContext() {
            // Render the view into the current graphics context
            self.layer.render(in: context)
            
            // Create an image from the current graphics context
            let image = UIGraphicsGetImageFromCurrentImageContext()
            
            // Clean up
            UIGraphicsEndImageContext()
            
            return image
        }
        return nil
    }
}

