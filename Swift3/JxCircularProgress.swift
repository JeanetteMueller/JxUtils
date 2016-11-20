//
//  JxCircularProgress.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 07.11.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit



enum JxCircularProgressTextPosition: Int {
    case none = -1,
    center,
    bottom,
    lineEndpoint
}

@IBDesignable

class JxCircularProgress: UIView {
    
    var textPosition:JxCircularProgressTextPosition = .center
    
    public var dotSize:CGFloat = 3
    @IBInspectable public var circleColor:UIColor = UIColor.red
    private var percent : Float = Float(0)
    @IBInspectable public var lineWidth:CGFloat = CGFloat(10)
    public var textLabel:UILabel
    @IBInspectable public var useEndDot:Bool = true
    
    private var startAngle: CGFloat = CGFloat(M_PI) * CGFloat(1.5)
    private var endAngle: CGFloat = CGFloat(M_PI) * CGFloat(1.5) + CGFloat(M_PI * 2)
    @IBInspectable public var startDegree: CGFloat = -90.0;
    private var circle: CAShapeLayer?
    private var dot: CAShapeLayer?
    
    
    public func setPercent(_ percent:Float, withAnimationDuration duration:CGFloat) {
        self.percent = percent;
        
        let radius = (bounds.size.width / 2) - lineWidth;
        
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.width / 2)
        
        if circle == nil {
            self.draw(self.bounds)
        }
        
        
        circle?.path = UIBezierPath.init(arcCenter: center,
                                              radius: radius,
                                              startAngle: radiantFrom(startDegree),
                                              endAngle: radiantFrom(( 360.0 / 100.0 * CGFloat(percent)  ) + startDegree),
                                              clockwise: true).cgPath
        
        
        
        
        circle?.strokeColor = circleColor.cgColor
        circle?.lineWidth = lineWidth;
        
        
        if duration > 0.0 {
            let circleAnimation = CABasicAnimation.init(keyPath: "strokeEnd")
            circleAnimation.fromValue = 0
            circleAnimation.toValue = 1
            circleAnimation.duration = CFTimeInterval(duration)
            
            circle?.add(circleAnimation, forKey: "strokeEnd")
        }
        
        
        
        
        let degree:CGFloat = ((360.0/100.0 * CGFloat(percent)) - 90) * CGFloat(M_PI / 180)
        
        let hypotenuse:CGFloat  = (bounds.size.width ) / 2;
        
        
        if useEndDot {
            let dotRect:CGRect = CGRect(x: center.x + (hypotenuse-(lineWidth/2)) * cos(degree) - dotSize/2,
                                        y: center.y + (hypotenuse-(lineWidth/2)) * sin(degree) - dotSize/2,
                                        width: dotSize, height: dotSize)
            
            dot?.path = UIBezierPath.init(ovalIn: dotRect).cgPath;
            
            if duration > 0.0 {
                let dotAnimation:CAKeyframeAnimation = CAKeyframeAnimation.init(keyPath: "position")
                dotAnimation.duration = CFTimeInterval(duration)
                
                dotAnimation.path = UIBezierPath.init(arcCenter: CGPoint(x: center.x - dotRect.origin.x - dotSize/2,
                                                                         y: center.y - dotRect.origin.y - dotSize/2),
                                                      radius: radius,
                                                      startAngle:radiantFrom(startDegree),
                                                      endAngle:radiantFrom(( 360.0 / 100.0 * CGFloat(percent)  ) + startDegree),
                                                      clockwise:true).cgPath
                
                dotAnimation.calculationMode = kCAAnimationPaced;
                dotAnimation.isRemovedOnCompletion = false
                dot?.fillColor = circleColor.cgColor;
                dot?.add(dotAnimation, forKey: "position")
            }
        }
        
        let distance:CGFloat = CGFloat(36)
        let textSize:CGSize = CGSize(width:70, height:20)
        
        let circleRect = CGRect(x: center.x-radius, y: center.y-radius, width: radius*2, height: radius*2)
        
        switch (self.textPosition) {
        case .center:
            self.textLabel.frame = CGRect(x: circleRect.origin.x, y: circleRect.origin.y + (circleRect.size.width / 2.0) - 45/2.0, width: circleRect.size.width, height:45)
            
            break
        case .bottom:
            self.textLabel.frame = CGRect(x: circleRect.origin.x, y: circleRect.origin.y + circleRect.size.height, width: circleRect.size.width, height: 45)
            
            break
        case .lineEndpoint:
            
            self.textLabel.frame = CGRect(x: center.x + (hypotenuse+distance-(lineWidth/2)) * cos(degree) - textSize.width/2,
                                          y: center.y + (hypotenuse+distance-(lineWidth/2)) * sin(degree) - textSize.height/2,
                                          width: textSize.width,
                                          height: textSize.height);
            
            let textAnimation = CAKeyframeAnimation.init(keyPath: "position")
            textAnimation.duration = CFTimeInterval(duration);
            textAnimation.path = UIBezierPath.init(arcCenter: CGPoint(x: center.x, y: center.y ),
                                                   radius:radius+distance,
                                                   startAngle:radiantFrom(startDegree),
                                                   endAngle:radiantFrom(( 360.0 / 100.0 * CGFloat(percent)  ) + startDegree),
                                                   clockwise:true).cgPath;
            textAnimation.calculationMode = kCAAnimationPaced
            textAnimation.isRemovedOnCompletion = false
            self.textLabel.layer.add(textAnimation, forKey: "position")
            
            break
        default:
            break
        }
    }
    public func setProgressText(_ progressText:String){
        self.textLabel.text = progressText;
        
        self.setNeedsDisplay()
    }
    
    
    
    required init?(coder aDecoder: NSCoder){
        
        let textLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 70, height: 20))
        textLabel.backgroundColor = UIColor.clear
        textLabel.textColor = UIColor.blue
        textLabel.textAlignment = .center
        textLabel.isUserInteractionEnabled = false
        
        self.textLabel = textLabel
        
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
    }
    
    override init(frame: CGRect){
        
        let textLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 70, height: 20))
        textLabel.backgroundColor = UIColor.clear
        textLabel.textColor = UIColor.blue
        textLabel.textAlignment = .center
        textLabel.isUserInteractionEnabled = false
        
        self.textLabel = textLabel
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
    }
    
    func radiantFrom(_ degree:CGFloat) -> CGFloat{
        return degree * CGFloat(M_PI) / 180;
    }
    
    func degreeFrom(_ radiant:CGFloat) -> CGFloat{
        return radiant * 180 / CGFloat(M_PI);
    }
    
    override func draw(_ rect: CGRect){
        if circle == nil {
            let circle = CAShapeLayer()
            circle.fillColor = nil;
            
            self.circle = circle
            self.layer.addSublayer(circle)
        }
        
        if dot == nil && self.useEndDot {
            let dot = CAShapeLayer()
            
            self.dot = dot
            self.layer.addSublayer(dot)
        }
    
        if textPosition != .none {
            self.addSubview(textLabel)
        }
    }
}