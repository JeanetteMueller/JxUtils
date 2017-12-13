//
//  String+Filename.swift
//  Podcat 2
//
//  Created by Jeanette Müller on 13.12.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import Foundation

extension String {
    
    func fileName() -> String {
        
        if let fileNameWithoutExtension = NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent {
            return fileNameWithoutExtension
        } else {
            return ""
        }
    }
    
    func fileExtension() -> String {
        
        if let fileExtension = NSURL(fileURLWithPath: self).pathExtension {
            return fileExtension
        } else {
            return ""
        }
    }
}
