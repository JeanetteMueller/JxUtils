//
//  String+base64.swift
//  Podcat 2
//
//  Created by Jeanette Müller on 02.04.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import Foundation

extension Data {
    //: ### Base64 encoding a string
    func base64Encoded() -> String {
        return self.base64EncodedString()
    }
    func base64_Encoded() -> String {
        return self.base64Encoded()
    }
}
extension String {
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //: ### Base64 decoding a string
    func base64Decoded() -> Data? {
        if let data = Data(base64Encoded: self) {
            return data
        }
        return nil
    }

    func base64_Encoded() -> String? {
        return self.base64Encoded()
    }

    //: ### Base64 decoding a string
    func base64_Decoded() -> Data? {
        return self.base64Decoded()
    }
}
