//
//  AnimateGraph.swift
//  Blood Glucose Readings Simplified
//
//  Created by Whitney Naquin on 6/7/21.
//

import Foundation
import UIKit

class AnimateGraph {
    
    func drawPaths(onView currentView: UIView) {
        let drawnPath = UIBezierPath()
        let shapeLayer = CAShapeLayer()
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawnPath.move(to: CGPoint(x: 0.0, y: currentView.frame.height/2))
        drawnPath.addLine(to: CGPoint(x: currentView.frame.width, y: currentView.frame.height/2))
        
        shapeLayer.path = drawnPath.cgPath
        shapeLayer.strokeColor = Constants.crimsonRGB.cgColor
        shapeLayer.lineCap = .butt
//        shapeLayer.borderWidth = 12.0
//        shapeLayer.borderColor = UIColor.black.cgColor
        shapeLayer.strokeEnd = 0.0
        shapeLayer.lineWidth = currentView.frame.height
//        shapeLayer.lineWidth = 10
        basicAnimation.toValue = 0.75
        basicAnimation.duration = 2
        //keep the path from dissapearing when finished
            //teacher not sure what this line does but you need it for the animation to stay
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
            //keeps the the animation from dissapearing
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "baby")
        currentView.layer.addSublayer(shapeLayer)
    }
    
//shrink the red and grow the green
    func erasePaths() {
        
    }
    
    func animateLabelWidth() {
        
    }
}
