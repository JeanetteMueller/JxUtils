//
//  UIViewController+Appearance.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 07.11.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit

extension UIViewController {
    
    @objc func updateAppearance(){
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
    
    func animateView(inView view:UIView,
                     withDuration duration:TimeInterval = 0.4,
                     toStateWithParameters params:[String:Any] = [String:Any](),
                     withFlashColor flashColor:UIColor? = nil,
                     completion completionBlock: (() -> Swift.Void)? = nil) {
        
        var animate = false
        
        func compare(a: Any, b: Any) -> Bool {
            
            if      let va = a as? Int, let vb = b as? Int          { return va == vb }
            else if let va = a as? Float, let vb = b as? Float      { return va == vb }
            else if let va = a as? CGFloat, let vb = b as? CGFloat  { return va == vb }
            else if let va = a as? Double, let vb = b as? Double    { return va == vb }
            else if let va = a as? String, let vb = b as? String    { return va == vb }
            else if let va = a as? Bool, let vb = b as? Bool        { return va == vb }
            else if let va = a as? Image, let vb = b as? Image      { return va == vb }
            else if let va = a as? UIColor, let vb = b as? UIColor  { return va.isEqual(vb)}
            
            
            //ignore other types
            return true
        }
        
        for key in params.keys {
  
            let isValue = self.value(forKeyPath:key) as Any
            let shouldBeValue = params[key] as Any
            
            if compare(a: isValue, b:shouldBeValue) == false{
                print("key ist nicht identisch", key)
                
                animate = true
            }
        }
        
        if (animate) {
            
            self.clipsToBounds = false
            
            let originalTransform:CGAffineTransform = self.transform;
            
            if let flash = flashColor{
                self.layer.shadowRadius = 0.0
                self.layer.shadowColor = flash.cgColor
                self.layer.shadowOffset = CGSize.zero
                self.layer.shadowOpacity = 1.0
                
                let anim = CABasicAnimation.init(keyPath: "shadowRadius")
                anim.fromValue = 0.0
                anim.toValue = 8.0
                anim.duration = (duration * 0.82) / 2
                anim.autoreverses = true
                anim.beginTime = CACurrentMediaTime() + (duration * 0.18)
                self.layer.add(anim, forKey: "shadowRadius")
            }
            
            UIView.animateKeyframes(withDuration: duration,
                                    delay: 0,
                                    options: [.allowUserInteraction, .beginFromCurrentState],
                                    animations: {
                                        
                                        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.18, animations: {
                                            
                                            self.transform = originalTransform.concatenating(CGAffineTransform(scaleX: 0, y: 0));
                                            view.layoutIfNeeded()
                                        })
                                        UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.03, animations: {
                                            
                                            for key in params.keys{
                                                self.setValue(params[key], forKeyPath:key)
                                            }
                                        })
                                        UIView.addKeyframe(withRelativeStartTime: 0.18, relativeDuration: 0.25, animations: {
                                            
                                            if let flash = flashColor{
                                                self.backgroundColor = flash
                                            }
                                            
                                            self.transform = originalTransform.concatenating(CGAffineTransform(scaleX: 1.15, y: 1.15))
                                            view.layoutIfNeeded()
                                        })
                                        UIView.addKeyframe(withRelativeStartTime: 0.43, relativeDuration: 0.25, animations: {
                                            self.transform = originalTransform.concatenating(CGAffineTransform(scaleX: 0.9, y: 0.9))
                                            view.layoutIfNeeded()
                                        })
                                        UIView.addKeyframe(withRelativeStartTime: 0.68, relativeDuration: 0.32, animations: {
                                            
                                            if let back = params["backgroundColor"] as? UIColor{
                                                self.backgroundColor = back
                                            }
                                            
                                            self.transform = originalTransform.concatenating(CGAffineTransform(scaleX: 1, y: 1))
                                            view.layoutIfNeeded()
                                        })
                                        
                                        
            }, completion: { (done) in
                
                if let b = completionBlock{
                    b()
                }
                
            })
        }
    }
}
