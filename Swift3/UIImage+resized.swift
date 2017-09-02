//
//  UIImage+resized.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 03.11.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit

class UIImageCache:NSCache<NSString, UIImage> {
    static let shared: UIImageCache = {
        
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
    class func getImage(withImageString imageString:String, andSize size:CGSize?, useCache cache:Bool = true) -> UIImage?{
        
        let imagePath = UIImage.getFilePath(withUrlString: imageString)
        
        return UIImage.getImage(withImagePath: imagePath, andSize: size, useCache: cache)
    }
    class func getImage(withImagePath imagePath:String, andSize size:CGSize?, useCache cache:Bool = true) -> UIImage?{
        var useSize:CGSize
        
        if var mySize = size {
            
            
            
            
            if mySize.width < 50 || mySize.height < 50 {
                
                mySize = CGSize(width: 50, height: 50)
            }
            
            let factor = mySize.width / mySize.height
            
            let newHeight = Math.ceilToTens(x: mySize.height)
            
            useSize = CGSize(width: newHeight * factor, height: newHeight)
            
        }else{
            useSize = CGSize(width: 1000, height: 1000)
        }
        
        var image:UIImage? = nil
        if let imagePathWithSize = UIImage.pathToResizedImage(fromPath: imagePath, toSize: useSize, useCache: cache){
            
            if let storedImage = UIImageCache.shared.object(forKey: imagePathWithSize as NSString){
                return storedImage
            }else{
                image = UIImage(contentsOfFile: imagePathWithSize)
                if let storeImage = image{
                    if cache{
                        UIImageCache.shared.setObject(storeImage, forKey: imagePathWithSize as NSString)
                    }
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
    class func pathToResizedImage(fromPath path:String, toSize size:CGSize, fileExtension ext:String = "png", useCache cache:Bool = true) -> String? {
        if FileManager.default.fileExists(atPath: path) {

            let newFilename = path.appending("_").appendingFormat("%d", Int(size.width)).appending("-").appendingFormat("%d", Int(size.height)).appending(".").appending(ext)
            
            if FileManager.default.fileExists(atPath: newFilename) {
                //print("resized file exitiert schon", newFilename)
                return newFilename
            }
            
            var originalImagePath = path
            
            if size.width == size.height{
                //quadrat
                if size.width < 1000{
                    
                    for x in [1000, 800, 600, 500, 400, 300, 240, 220, 200, 180, 160, 150, 140, 120, 110, 100, 80]{
                        
//                        print("imagesize with width", x)
                        if size.width < CGFloat(x){
                            let allReadyResizedVersionPath = path.appending("_").appendingFormat("%d", x).appending("-").appendingFormat("%d", x).appending(".").appending(ext)
                            
                            if FileManager.default.fileExists(atPath: allReadyResizedVersionPath) {
                                print("verwende als original eine bereits verkleinerte version um speicher zu schonen", newFilename)
                                originalImagePath = allReadyResizedVersionPath
                                break
                            }
                        }
                    }
                }
            }
            
            if let original = UIImage(contentsOfFile: originalImagePath){
                
                let newImage = UIImage.createImage(fromOriginal: original, withSize: size)
                
                if let saveImage = newImage {
                    let imageData = UIImagePNGRepresentation(saveImage)! as NSData
                    
                    imageData.write(toFile: newFilename as String, atomically: true)
                    
                    if cache {
                        UIImageCache.shared.setObject(saveImage, forKey: newFilename as NSString)
                    }
                    let url = URL.init(fileURLWithPath: newFilename)
                    
                    if url.skipBackupAttributeToItemAtURL(true){
                        //print("downloaded file is excluded from backup")
                    }else{
                        print("UIImage: pathToResizedImage - exclude from backup failed:", url)
                    }
                    
                    return newFilename;
                }
            }
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

