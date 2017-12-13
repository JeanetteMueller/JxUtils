//
//  String+html.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 14.02.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    static func cleanUp(fromHTML html:String) -> String{
        

        if let data = html.data(using: String.Encoding.unicode){
            
            do {
                let attrStr = try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
                
                var result = attrStr.string
                result = result.replacingOccurrences(of: "<hr>", with: "\n--------\n")
                result = result.replacingOccurrences(of: "<hr \\>", with: "\n--------\n")
                result = result.replacingOccurrences(of: "\n\n\n\n\n", with: "\n\n")
                result = result.replacingOccurrences(of: "\n\n\n\n", with: "\n\n")
                result = result.replacingOccurrences(of: "\n\n\n", with: "\n\n")
                
                return result

            } catch let error as NSError {
                print("ERROR: ", error.localizedDescription)
            }
        }
        
        return "conversino failed"
        
    }
    
    //swift 4
//    var htmlDecoded: String {
//        let decoded = try? NSAttributedString(data: Data(utf8), options: [
//            .documentType: NSAttributedString.DocumentType.html,
//            .characterEncoding: String.Encoding.utf8.rawValue
//            ], documentAttributes: nil).string
//
//        return decoded ?? self
//    }
    
    var htmlDecoded: String? {
        
        if let encodedData = self.data(using: String.Encoding.utf8){
            let attributedOptions = [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                      NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue] as [String : Any]
            
            if let attributedString = try? NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil){
                return attributedString.string
            }
        }
        return self
    }
}
