//
//  String+md5.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 07.10.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import Foundation

/*
 You have to add
 #import <CommonCrypto/CommonCrypto.h>
 to your Objective-C Bridging Header File
 */


extension String {
    // new functionality to add to SomeType goes here
    
    func md5() -> String {
        
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, self, CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate(capacity: 1)
        var hexString = ""
        for byte in digest {
            hexString += String(format:"%02x", byte)
        }
        
        return hexString
    }
    
}


extension NSURL {
    // new functionality to add to SomeType goes here
    
    func md5() -> String {
        
        
        let urlString = self.absoluteString! as String
        
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, urlString, CC_LONG(urlString.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate(capacity: 1)
        var hexString = ""
        for byte in digest {
            hexString += String(format:"%02x", byte)
        }
        
        return hexString
    }
    
}

extension URL {
    // new functionality to add to SomeType goes here
    
    func md5() -> String {
        
        let urlString = self.absoluteString as String
        
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, urlString, CC_LONG(urlString.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate(capacity: 1)
        var hexString = ""
        for byte in digest {
            hexString += String(format:"%02x", byte)
        }
        
        return hexString
    }
    
}
