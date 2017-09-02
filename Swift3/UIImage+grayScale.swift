//
//  UIImage+grayScale.swift
//  projectPhoenix
//
//  Created by Jeanette Müller on 15.12.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit

extension UIImage {
    
    func grayScaleImage() -> UIImage {
        
        // Create image rectangle with current image width/height
        let imageRect = CGRect(x:0, y:0, width:self.size.width, height:self.size.height);
        
        // Grayscale color space
        let colorSpace = CGColorSpaceCreateDeviceGray();
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        
        // Create bitmap content with current image size and grayscale colorspace
        if let context = CGContext(data: nil, width: Int(imageRect.size.width), height: Int(imageRect.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue){
            
            // Draw image into current context, with specified rectangle
            // using previously defined context (with grayscale colorspace)
            context.draw(self.cgImage!, in: imageRect)
            
            // Create bitmap image info from pixel data in current context
            if let imageRef = context.makeImage(){
                
                // Create a new UIImage object
                let newImage = UIImage(cgImage: imageRef)
                
                // Return the new grayscale image
                return newImage
            }
        }
        return self
    }
}
