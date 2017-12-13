//
//  UIView+copy.swift
//  Podcat 2
//
//  Created by Jeanette Müller on 04.04.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import UIKit

extension UIView
{
    func copyView<T: UIView>() -> T? {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as? T
    }
}
