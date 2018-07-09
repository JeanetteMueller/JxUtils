//
//  CGFloat+random.swift
//  HomeLCARS
//
//  Created by Jeanette Müller on 29.01.18.
//  Copyright © 2018 Jeanette Müller. All rights reserved.
//

import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

