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
    class func getImage(withImageString imageString:String, andSize size:CGSize?, withMode mode:UIView.ContentMode, useCache cache:Bool = true) -> UIImage?{
        
        if let i = UIImage(named: imageString){
            return i
        }
        
        let imagePath = UIImage.getFilePath(withUrlString: imageString)
        
        return UIImage.getImage(withImagePath: imagePath, andSize: size, withMode: mode, useCache: cache)

    }
    class func getImage(withImagePath imagePath:String, andSize size:CGSize?, withMode mode:UIView.ContentMode, useCache cache:Bool = true) -> UIImage?{
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
        if let imagePathWithSize = UIImage.pathToResizedImage(fromPath: imagePath, toSize: useSize, withMode: mode, useCache: cache){
            
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
    class func pathToResizedImage(fromUrl urlString:String, toSize size:CGSize, withMode mode:UIView.ContentMode) -> String? {
        let sourcePath = UIImage.getFilePath(withUrlString:urlString)
        
        return UIImage.pathToResizedImage(fromPath: sourcePath, toSize: size, withMode: mode)
    }
    class func pathToResizedImage(fromPath path:String, toSize size:CGSize, withMode mode:UIView.ContentMode, fileExtension ext:String = "png", useCache cache:Bool = true) -> String? {
        if FileManager.default.fileExists(atPath: path) {

            let modeString = String(format: "mode_%d", mode.rawValue)
            
            let newFilename = path.appending("_").appendingFormat("%d", Int(size.width)).appending("-").appendingFormat("%d", Int(size.height)).appending("-").appending(modeString).appending(".").appending(ext)
            
            if FileManager.default.fileExists(atPath: newFilename) {
                //log("resized file exitiert schon", newFilename)
                return newFilename
            }
            
            var originalImagePath = path
            
            if size.width == size.height{
                //quadrat
                if size.width < 1000{
                    
                    for x in [1000, 800, 600, 500, 400, 300, 240, 220, 200, 180, 160, 150, 140, 120, 110, 100, 80, 70, 60]{
                        
//                        log("imagesize with width", x)
                        if size.width < CGFloat(x){
                            let allReadyResizedVersionPath = path.appending("_").appendingFormat("%d", x).appending("-").appendingFormat("%d", x).appending(".").appending(ext)
                            
                            if FileManager.default.fileExists(atPath: allReadyResizedVersionPath) {
                                originalImagePath = allReadyResizedVersionPath
                                break
                            }
                        }
                    }
                }
            }
            
            if let original = UIImage(contentsOfFile: originalImagePath){
                
                if let saveImage = UIImage.createImage(fromOriginal: original, withSize: size, withMode: mode) {
                    
                    if let imageData = saveImage.pngData() as NSData?{
                    
                        if FileManager.default.fileExists(atPath: newFilename) {
                            //log("resized file exitiert schon", newFilename)
                            try? FileManager.default.removeItem(atPath: newFilename)
                        }
                        imageData.write(toFile: newFilename as String, atomically: true)
                    
                    }
                    if cache {
                        UIImageCache.shared.setObject(saveImage, forKey: newFilename as NSString)
                    }
                    let url = URL(fileURLWithPath: newFilename)
                    
                    if url.skipBackupAttributeToItemAtURL(true){
                        //log("downloaded file is excluded from backup")
                    }else{
                        log("UIImage: pathToResizedImage - exclude from backup failed:", url)
                    }
                    
                    return newFilename;
                }
            }
        }
        return nil
    }
    
    class func createImage(fromOriginal original: UIImage, withSize size:CGSize, withMode mode:UIView.ContentMode) -> UIImage?{
//        log("create resized image")
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        UIRectFill(CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        
        let ratioX = original.size.width / size.width
        let ratioY = original.size.height / size.height
        
        //max zeigt ganzes bild mit schwarzen balken
        //min vergrößert das bild und schneidet den rest ab
        
        var ratio:CGFloat = 0
        
        switch mode {
        case .scaleAspectFill, .scaleToFill:
            ratio = min(ratioX, ratioY)
            
            let newWidth = original.size.width/ratio
            let newHeight = original.size.height/ratio
            
            original.draw(in: CGRect(x: (size.width - newWidth) / 2,
                                     y: (size.height - newHeight) / 2,
                                     width: newWidth,
                                     height: newHeight))
            
            
        default:
            ratio = max(ratioX, ratioY)
            
            var originX: CGFloat = 0
            var originY: CGFloat = 0
            let sizeWidth: CGFloat = original.size.width/ratio
            let sizeHeight: CGFloat = original.size.height/ratio
            
            switch mode {
                
            case .top:
                originX = (size.width - sizeWidth) / 2
                originY = 0
                break
            case .bottom:
                originX = (size.width - sizeWidth) / 2
                originY = size.height - sizeHeight
                break
            default:
                originX = (size.width - sizeWidth) / 2
                originY = (size.height - sizeHeight) / 2
                break;
            }
            
            original.draw(in: CGRect(x: originX,
                                     y: originY,
                                     width: sizeWidth,
                                     height: sizeHeight))
        }
        
        
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func getQuadratImage(andCropToBounds crop: Bool = true) -> UIImage {
        
        let image = self
        var quadratSize = CGSize(width: 100, height: 100)
        
        if crop {
            quadratSize = CGSize(width: min(image.size.width, image.size.height), height: min(image.size.width, image.size.height))
        } else {
            quadratSize = CGSize(width: max(image.size.width, image.size.height), height: max(image.size.width, image.size.height))
        }
        
        UIGraphicsBeginImageContextWithOptions(quadratSize, false, 0.0)
        
        image.draw(in: CGRect(x: (quadratSize.width - image.size.width) / 2,
                              y: (quadratSize.height - image.size.height) / 2,
                              width: image.size.width,
                              height: image.size.height))
        
        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return newImage
        } else {
            UIGraphicsEndImageContext()
            return image
        }
    }
}

