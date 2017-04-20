//
//  UIImage+svgKit.swift
//  Podcat 2
//
//  Created by Jeanette Müller on 27.03.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import UIKit
import SVGKit

extension UIImage {

    static func svgImage(withName name:String, andSize size:CGSize?=nil, renderingMode mode:UIImageRenderingMode = .alwaysTemplate) -> UIImage?{
        
        if let svg = SVGKImage.init(named: name){
            
            if let customSize = size{
                svg.scaleToFit(inside: customSize)
            }
            
            if let image = svg.uiImage{
                return image.withRenderingMode(mode)
            }
        }
        return nil
    }
}
