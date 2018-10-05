//
//  UIDevice+DeviceType.swift
//  Podcat 2
//
//  Created by Jeanette Müller on 10.02.18.
//  Copyright © 2018 Jeanette Müller. All rights reserved.
//

import UIKit
import DeviceKit

enum UIDeviceType {
    case unknown
    case iPhone5Like, iPhone6Like, iPhone6PlusLike, iPhoneXLike
    case iPadLike
    case carPlay
    case tvLike
}

extension UIDevice {
    
    func hasCameraNotch() -> Bool {
//        if #available(iOS 11.0, *) {
//            return UIApplication.shared.delegate?.window??.safeAreaInsets != .zero
//        }
        
        if Device() == .iPhoneX ||
            Device() == .iPhoneXs ||
            Device() == .iPhoneXsMax ||
            Device() == .iPhoneXr{
            return true
        }
        
        
        return false
    }
    
}
