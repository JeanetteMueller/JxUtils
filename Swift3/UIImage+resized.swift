//
//  UIImage+resized.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 03.11.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func getFolderPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        var documentsDirectory = paths[0] as String
        
        if let containerPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: kGroupIdentifier){
            documentsDirectory = containerPath.path
        }
        
        return documentsDirectory.appending("/images")
    }
    class func getFilePath(withUrl url:URL) -> String {
        
        let imageDir = UIImage.getFolderPath()
        
        return imageDir.appending("/").appending(url.md5())
    }
    class func getFilePath(withUrlString urlString:String) -> String {
        
        let imageDir = UIImage.getFolderPath()
        
        return imageDir.appending("/").appending(urlString.md5())
    }
    class func getImage(withImageString imageString:String, andSize size:CGSize?) -> UIImage?{
        var useSize:CGSize
        if !(size != nil) {
            useSize = CGSize(width: 1000, height: 1000)
        }else{
            useSize = size!
        }
        
        let imagePath = UIImage.getFilePath(withUrlString: imageString)
        
        if let imagePath = UIImage.pathToResizedImage(fromPath: imagePath, toSize: useSize){
            return UIImage.init(contentsOfFile: imagePath)
        }
        return nil
    }
    class func getImage(withImagePath imagePath:String, andSize size:CGSize?) -> UIImage?{
        var useSize:CGSize
        if !(size != nil) {
            useSize = CGSize(width: 1000, height: 1000)
        }else{
            useSize = size!
        }
        if let imagePath = UIImage.pathToResizedImage(fromPath: imagePath, toSize: useSize){
            return UIImage.init(contentsOfFile: imagePath)
        }
        return nil
    }
    
    class func pathToResizedImage(fromPath path:String, toSize size:CGSize) -> String? {
        if FileManager.default.fileExists(atPath: path) {
            print("original exitiert")
            let newFilename = path.appending("_").appendingFormat("%d", Int(size.width)).appending("-").appendingFormat("%d", Int(size.height))
            
            if FileManager.default.fileExists(atPath: newFilename) {
                print("resized file exitiert schon")
                return newFilename
            }
            
            if let original = UIImage.init(contentsOfFile: path){
                
                let newImage = UIImage.createImage(fromOriginal: original, withSize: size)
                
                if newImage != nil {
                    let imageData = UIImagePNGRepresentation(newImage!)! as NSData
                    
                    imageData.write(toFile: newFilename as String, atomically: true)
                    
                    return newFilename;
                }
            }
        }else{
            print("kann original nicht finden")
        }
        return nil
    }
    
    class func createImage(fromOriginal original: UIImage, withSize size:CGSize) -> UIImage?{
    
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        original.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

