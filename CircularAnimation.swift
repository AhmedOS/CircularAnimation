//
//  CircularAnimation.swift
//  CircularAnimation
//
//  Created by Ahmed Osama on 3/28/19.
//  Copyright © 2019 Ahmed Osama. All rights reserved.
//  https://github.com/AhmedOS/CircularAnimation

import UIKit

class CircularAnimation {
    
    /// Array of views to be animated.
    var views = [UIView]()
    
    /// Virtual circle radius.
    var radius: Float = 0
    
    /// Virtual circle center.
    var origin = CGPoint(x: 0, y: 0)
    
    /// Angle which views start animating from, measured in **degrees**.
    /// Valid value must lay in range **[0, 360]**.
    var sourceAngle: Float = 0
    
    /// The beginning angle which views distribute themselves starting from it, measured in **degrees**.
    /// Valid value must lay in range **[0, 360]**.
    var startAngle: Float = 0
    
    /// Amount of degrees used to distribute views within them starting from `startAngle`.
    /// Valid value must lay in range **[-360, 360]**.
    /// * Positive value will result in a clockwise animation.
    /// * Negative value will result in a counter-clockwise animation.
    var degrees: Float = 0
    
    /// Indicates whether the final shape is meant to be a full circle or not.
    /// * Generally, mark it as `true` if both first and last views overlap on each other.
    var fullCircle = false
    
    /// Duration of animation for each view in **seconds**.
    var duration: CFTimeInterval = 0
    
    /// The delay between animating views in **seconds**.
    var delay: CFTimeInterval = 0
    
    /// A timing function defining the pacing of the animation.
    var timingFunction = TimingFunction.easeOutQuint()
    
    /// The order which views will be animated in.
    var animatingOrder: AnimatingOrder = .default
    
    func animate(mode: Mode, options: Options? = nil) {
        
        guard validValues() else {
            return
        }
        
        let one: Float = degrees >= 0 ? 1 : -1
        let viewsDegreesDiff = abs(degrees) / Float(views.count - (fullCircle ? 0 : 1))
        let clockwise = degrees >= 0
        let sourceStartDegreesDiff = degreesDifference(a: sourceAngle, b: startAngle, clockwise: clockwise)
        
        for index in 0 ..< views.count {
            
            let view = views[index]
            
            let totalDegrees = sourceStartDegreesDiff + (viewsDegreesDiff * Float(index))
            let totalValues = totalDegrees / 0.1
            let strid = stride(from: 0, to: totalDegrees, by: 0.1)
            
            var values = [CGPoint]()
            var keyTimes = [NSNumber]()
            var valueCount: Float = 0
            var angle = sourceAngle
            for _ in strid {
                if angle < 0 {
                    angle = 359.9
                }
                if angle >= 360 {
                    angle = 0
                }
                values.append(getPointOnCircle(angle: angle))
                keyTimes.append(NSNumber(value: valueCount / totalValues))
                valueCount += 1
                angle += 0.1 * one
            }
            
            if mode == .exit {
                values.reverse()
            }
            
            let sourcePoint = getPointOnCircle(angle: sourceAngle)
            DispatchQueue.main.async {
                view.center = values.first ?? sourcePoint
            }
            
            let keyPath = "position"
            let animation = CAKeyframeAnimation()
            animation.keyPath = keyPath
            animation.values = values
            animation.keyTimes = keyTimes
            animation.duration = options?.duration ?? duration
            animation.timingFunction = options?.timingFunction ?? timingFunction
            
            let animOrder = options?.animatingOrder ?? animatingOrder
            let delayCount = Double(animOrder == .default ? index : views.count - index)
            let delayValue = options?.delay ?? delay
            DispatchQueue.main.asyncAfter(deadline: .now() + (delayValue * delayCount)) {
                view.layer.position = values.last ?? view.layer.position
                // Change model layer, as animation chnges presentation layer only
                view.layer.add(animation, forKey: keyPath)
                // Use the name of the animated property as key to override the implicit animation
                // https://oleb.net/blog/2012/11/prevent-caanimation-snap-back/
            }
            
        }
        
    }
    
    fileprivate func validValues() -> Bool {
        guard sourceAngle >= 0 && sourceAngle <= 360 else {
            return false
        }
        guard startAngle >= 0 && startAngle <= 360 else {
            return false
        }
        guard degrees >= -360 && degrees <= 360 else {
            return false
        }
        return true
    }
    
    fileprivate func degreesDifference(a: Float, b: Float, clockwise: Bool) -> Float {
        if clockwise {
            if a <= b {
                return b - a
            }
            else {
                let p1 = 360 - a
                let p2 = b
                return p1 + p2
            }
        }
        else {
            if a >= b {
                return a - b
            }
            else {
                let p1 = a
                let p2 = 360 - b
                return p1 + p2
            }
        }
    }
    
    fileprivate func getPointOnCircle(angle: Float) -> CGPoint {
        let x = Float(origin.x) + radius * cos(angle / 180 * Float.pi)
        let y = Float(origin.y) + radius * sin(angle / 180 * Float.pi)
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
    
}

extension CircularAnimation {
    
    enum Mode {
        case enter
        case exit
    }
    
    enum AnimatingOrder {
        case `default`
        case reversed
    }
    
    struct Options {
        var animatingOrder: AnimatingOrder?
        var duration: CFTimeInterval?
        var delay: CFTimeInterval?
        var timingFunction: CAMediaTimingFunction?
    }
    
    struct TimingFunction {
        // https://gist.github.com/naoyashiga/2673e55a9b5212fd0897
        // Visualization: https://easings.net/en
        static func easeOutQuint() -> CAMediaTimingFunction {
            return CAMediaTimingFunction(controlPoints: 0.23, 1, 0.32, 1)
        }
        static func easeOutQuart() -> CAMediaTimingFunction {
            return CAMediaTimingFunction(controlPoints: 0.165, 0.84, 0.44, 1)
        }
        static func easeOutExpo() -> CAMediaTimingFunction {
            return CAMediaTimingFunction(controlPoints: 0.19, 1, 0.22, 1)
        }
        static func easeInQuint() -> CAMediaTimingFunction {
            return CAMediaTimingFunction(controlPoints: 0.755, 0.05, 0.855, 0.06)
        }
        static func easeInQuart() -> CAMediaTimingFunction {
            return CAMediaTimingFunction(controlPoints: 0.895, 0.03, 0.685, 0.22)
        }
        static func easeInExpo() -> CAMediaTimingFunction {
            return CAMediaTimingFunction(controlPoints: 0.95, 0.05, 0.795, 0.035)
        }
    }
    
}
