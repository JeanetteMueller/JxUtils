//
//  UIBarButtonItem.swift
//  Podcat 2
//
//  Created by Jeanette Müller on 07.09.18.
//  Copyright © 2018 Jeanette Müller. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    var frame: CGRect? {
        
        guard let view = self.value(forKey: "view") as? UIView else {
            return nil
        }
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate{
            if let base = delegate.window?.rootViewController{
                
                if let result = view.superview?.convert(view.frame, to: base.view){
                
                    return result
                }
            }
        }
        
        return view.frame
    }
    
}
