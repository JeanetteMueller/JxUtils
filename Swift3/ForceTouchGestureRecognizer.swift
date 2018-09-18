//
//  ForceTouchGestureRecognizer.swift
//  Podcat 2
//
//  Created by Jeanette Müller on 08.03.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

//Without this import line, you'll get compiler errors when implementing your touch methods since they aren't part of the UIGestureRecognizer superclass
import UIKit.UIGestureRecognizerSubclass

//Since 3D Touch isn't available before iOS 9, we can use the availability APIs to ensure no one uses this class for earlier versions of the OS.
@available(iOS 9.0, *)
public class ForceTouchGestureRecognizer: UIGestureRecognizer, UIGestureRecognizerDelegate {
    //Because we don't know what the maximum force will always be for a UITouch, the force property here will be normalized to a value between 0.0 and 1.0.
    public private(set) var force: CGFloat = 0.0
    public var maximumForce: CGFloat = 10.0
    
    convenience init() {
        self.init(target: nil, action: nil)
    }
    
    //We override the initializer because UIGestureRecognizer's cancelsTouchesInView property is true by default. If you were to, say, add this recognizer to a tableView's cell, it would prevent didSelectRowAtIndexPath from getting called. Thanks for finding this bug, Jordan Hipwell!
    public override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        cancelsTouchesInView = false
        requiresExclusiveTouchType = true
        self.delegate = self
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        normalizeForceAndFireEvent(.began, touches: touches)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        normalizeForceAndFireEvent(.changed, touches: touches)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        normalizeForceAndFireEvent(.ended, touches: touches)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        normalizeForceAndFireEvent(.cancelled, touches: touches)
    }
    
    private func normalizeForceAndFireEvent(_ state: UIGestureRecognizer.State, touches: Set<UITouch>) {
        //Putting a guard statement here to make sure we don't fire off our target's selector event if a touch doesn't exist to begin with.
        guard let firstTouch = touches.first else { return }
        
        guard state != .cancelled else {
            self.state = state
            return
        }
        
        //Just in case the developer set a maximumForce that is higher than the touch's maximumPossibleForce, I'm setting the maximumForce to the lower of the two values.
        let maxiForce = min(firstTouch.maximumPossibleForce, maximumForce)
        
        //Now that I have a proper maxiForce, I'm going to use that and normalize it so the developer can use a value between 0.0 and 1.0.
        force = firstTouch.force / maxiForce
        
        //Our properties are now ready for inspection by the developer. By setting the UIGestureRecognizer's state property, the system will automatically send the target the selector message that this recognizer was initialized with.
        self.state = state
    }
    
    //This function is called automatically by UIGestureRecognizer when our state is set to .Ended. We want to use this function to reset our internal state.
    public override func reset() {
        super.reset()
        force = 0.0
    }
    
    // Mark: UIGestureRecognizerDelegate
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
