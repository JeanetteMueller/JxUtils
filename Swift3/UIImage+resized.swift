//
//  UIImage+resized.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 03.11.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit

class UIImageCache:NSCache<NSString, UIImage> {
    static let sharedInstance: UIImageCache = {
        
        let instance = UIImageCache()
        
        // setup code
        
        return instance
    }()
}
extension UIImage {

    
    class func getFilePath(withUrl url:URL) -> String {
        
        let imageDir = FileHelper.getImagesFolderPath()
        
        return imageDir.appending("/").appending(url.md5())
    }
    class func getFilePath(withUrlString urlString:String) -> String {
        
        let imageDir = FileHelper.getImagesFolderPath()
        
        return imageDir.appending("/").appending(urlString.md5())
    }
    class func getImage(withImageString imageString:String, andSize size:CGSize?) -> UIImage?{
        
        let imagePath = UIImage.getFilePath(withUrlString: imageString)
        
        return UIImage.getImage(withImagePath: imagePath, andSize: size)
    }
    class func getImage(withImagePath imagePath:String, andSize size:CGSize?) -> UIImage?{
        var useSize:CGSize
        
        if var mySize = size {
            
            while  mySize.width < 50 || mySize.height < 50 {
                mySize = CGSize(width: mySize.width*2, height: mySize.height*2)
            }
            
            let factor = mySize.width / mySize.height
            
            let newHeight = Math.ceilToTens(x: mySize.height)
            
            useSize = CGSize(width: newHeight * factor, height: newHeight)
            
        }else{
            useSize = CGSize(width: 1000, height: 1000)
        }
        
        var image:UIImage? = nil
        if let imagePathWithSize = UIImage.pathToResizedImage(fromPath: imagePath, toSize: useSize){
            
            if let storedImage = UIImageCache.sharedInstance.object(forKey: imagePathWithSize as NSString){
                print("use cached image")
                return storedImage
            }else{
                print("load image from storrage")
                image = UIImage.init(contentsOfFile: imagePathWithSize)
                if let storeImage = image{
                    
                    UIImageCache.sharedInstance.setObject(storeImage, forKey: imagePathWithSize as NSString)
                    return storeImage
                }
            }
        }
        return nil
    }
    class func pathToResizedImage(fromUrl urlString:String, toSize size:CGSize) -> String? {
        let sourcePath = UIImage.getFilePath(withUrlString:urlString)
        
        return UIImage.pathToResizedImage(fromPath: sourcePath, toSize: size)
    }
    class func pathToResizedImage(fromPath path:String, toSize size:CGSize) -> String? {
        if FileManager.default.fileExists(atPath: path) {
//            print("original exitiert")
            let newFilename = path.appending("_").appendingFormat("%d", Int(size.width)).appending("-").appendingFormat("%d", Int(size.height))
            
            if FileManager.default.fileExists(atPath: newFilename) {
//                print("resized file exitiert schon")
                return newFilename
            }
            
            if let original = UIImage.init(contentsOfFile: path){
                
                let newImage = UIImage.createImage(fromOriginal: original, withSize: size)
                
                if let saveImage = newImage {
                    let imageData = UIImagePNGRepresentation(saveImage)! as NSData
                    
                    imageData.write(toFile: newFilename as String, atomically: true)
                    
                    UIImageCache.sharedInstance.setObject(saveImage, forKey: newFilename as NSString)
                    
                    let url = URL.init(fileURLWithPath: newFilename)
                    if url.skipBackupAttributeToItemAtURL(true){
                        //print("downloaded file is excluded from backup")
                    }else{
                        print("exclude from backup failed:", url)
                    }
                    
                    return newFilename;
                }
            }
        }else{
            print("kann original nicht finden")
        }
        return nil
    }
    
    class func createImage(fromOriginal original: UIImage, withSize size:CGSize) -> UIImage?{
//        print("create resized image")
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        original.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

