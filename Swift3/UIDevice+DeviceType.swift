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
    
    func isIphoneX() -> Bool {
//        if #available(iOS 11.0, *) {
//            return UIApplication.shared.delegate?.window??.safeAreaInsets != .zero
//        }
        
        if Device() == .iPhoneX {
            return true
        }
        
//        if UIDevice().userInterfaceIdiom == .phone {
//            switch UIScreen.main.nativeBounds.height {
//            case 1136:
//                print("iPhone 5 or 5S or 5C")
//            case 1334:
//                print("iPhone 6/6S/7/8")
//            case 1920, 2208:
//                print("iPhone 6+/6S+/7+/8+")
//            case 2436:
//                print("iPhone X")
//                return true
//            default:
//                print("unknown")
//            }
//        }
        
        return false
    }
    func currentDeviceType() -> UIDeviceType {
        
        switch UIDevice().userInterfaceIdiom {
        case .phone:
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                return .iPhone5Like
            case 1334:
                print("iPhone 6/6S/7/8")
                return .iPhone6Like
            case 2208:
                print("iPhone 6+/6S+/7+/8+")
                return .iPhone6PlusLike
            case 2436:
                print("iPhone X")
                return .iPhoneXLike
            default:
                break
            }
        case .pad:
            print("iPad")
            return .iPadLike
        case .carPlay:
            print("carPlay")
            return .carPlay
        case .tv:
            print("TV")
            return .tvLike
        case .unspecified:
            break
        }
        print("unknown Device Type")
        return .unknown
    }
    
}
