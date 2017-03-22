//
//  UIViewController+Appearance.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 07.11.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func updateAppearance(){
        print("override this")
    }
    
}

extension UINavigationController {
    
    override func updateAppearance(){
        
        for vc in self.viewControllers{
            vc.updateAppearance()
        }
    }
}

extension UIView {
    
    func animateView(inView view:UIView, toStateWithParameters params:[String:Any]) {
        self.animateView(inView: view, toStateWithParameters: params) {
            //empty Completion Block
        }
    }
    func animateView(inView view:UIView, toStateWithParameters params:[String:Any], completion completionBlock: @escaping () -> Swift.Void) {
    
        animateView(inView: view, withDuration: 0.4, toStateWithParameters: params, completion: completionBlock)
    }
    func animateView(inView view:UIView, withDuration duration:Float, toStateWithParameters params:[String:Any]) {
        
        animateView(inView: view, withDuration: duration, toStateWithParameters: params){
            //empty Completion Block
        }
    }
    func animateView(inView view:UIView, withDuration duration:Float, toStateWithParameters params:[String:Any], completion completionBlock: @escaping () -> Swift.Void) {
        var animate = false
        
        func compare(a: Any, b: Any) -> Bool {
            
            if let va = a as? Int, let vb = b as? Int            {if va == vb {return true}}
            else if let va = a as? String, let vb = b as? String {if va == vb {return true}}
            else if let va = a as? Bool, let vb = b as? Bool     {if va == vb {return true}}
            
            return false
        }
        
        for key in params.keys {
            
            let isValue = self.value(forKey:key) as Any
            let shouldBeValue = params[key]  as Any
            
            if !compare(a: isValue, b:shouldBeValue) {
                animate = true
            }
        }
        
        if (animate) {
            
            let originalTransform:CGAffineTransform = self.transform;
            
            UIView.animateKeyframes(withDuration: 0.4,
                                    delay: 0,
                                    options: [.allowUserInteraction, .beginFromCurrentState],
                                    animations: {
                                        
                                        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.18, animations: {
                                            self.transform = originalTransform.concatenating(CGAffineTransform(scaleX: 0, y: 0));
                                            view.layoutIfNeeded()
                                        })
                                        
                                        self.setValuesForKeys(params)
                                        
                                        UIView.addKeyframe(withRelativeStartTime: 0.18, relativeDuration: 0.25, animations: {
                                            self.transform = originalTransform.concatenating(CGAffineTransform(scaleX: 1.1, y: 1.1))
                                            view.layoutIfNeeded()
                                        })
                                        UIView.addKeyframe(withRelativeStartTime: 0.43, relativeDuration: 0.25, animations: {
                                            self.transform = originalTransform.concatenating(CGAffineTransform(scaleX: 0.9, y: 0.9))
                                            view.layoutIfNeeded()
                                        })
                                        UIView.addKeyframe(withRelativeStartTime: 0.68, relativeDuration: 0.32, animations: {
                                            self.transform = originalTransform.concatenating(CGAffineTransform(scaleX: 1, y: 1))
                                            view.layoutIfNeeded()
                                        })
                                        
                                        
            }, completion: { (done) in
                completionBlock()
            })
        }
    }
}
