//
//  logoBezierPath.swift
//  Moodstory
//
//  Created by Muhammad Mustafa Saeed on 3/24/17.
//  Copyright © 2017 MoodStory. All rights reserved.
//

import Foundation
import UIKit

struct Paths {
    static func logoPath() -> CGPath {
    

            let fillColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)

            //// Bezier Drawing
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: 131.5, y: 76))
            bezierPath.addLine(to: CGPoint(x: 103.5, y: 76))
            bezierPath.addLine(to: CGPoint(x: 100, y: 76))
            bezierPath.addLine(to: CGPoint(x: 103.5, y: 72.38))
            bezierPath.addLine(to: CGPoint(x: 107, y: 76))
            bezierPath.addLine(to: CGPoint(x: 103.5, y: 76))
            bezierPath.addLine(to: CGPoint(x: 100, y: 76))
            bezierPath.addLine(to: CGPoint(x: 100, y: 43.51))
            bezierPath.addCurve(to: CGPoint(x: 117.5, y: 26), controlPoint1: CGPoint(x: 100, y: 33.84), controlPoint2: CGPoint(x: 107.83, y: 26))
            bezierPath.addCurve(to: CGPoint(x: 135, y: 43.51), controlPoint1: CGPoint(x: 127.16, y: 26), controlPoint2: CGPoint(x: 135, y: 33.84))
            bezierPath.addLine(to: CGPoint(x: 135, y: 76))
            bezierPath.addLine(to: CGPoint(x: 131.5, y: 76))
            bezierPath.addLine(to: CGPoint(x: 135, y: 76))
            bezierPath.addLine(to: CGPoint(x: 131.5, y: 72.38))
            bezierPath.addLine(to: CGPoint(x: 128, y: 76))
            bezierPath.addLine(to: CGPoint(x: 131.5, y: 76))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 110.5, y: 72.38))
            bezierPath.addLine(to: CGPoint(x: 114, y: 76))
            bezierPath.addLine(to: CGPoint(x: 107, y: 76))
            bezierPath.addLine(to: CGPoint(x: 110.5, y: 72.38))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 117.5, y: 72.38))
            bezierPath.addLine(to: CGPoint(x: 121, y: 76))
            bezierPath.addLine(to: CGPoint(x: 114, y: 76))
            bezierPath.addLine(to: CGPoint(x: 117.5, y: 72.38))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 124.5, y: 72.38))
            bezierPath.addLine(to: CGPoint(x: 128, y: 76))
            bezierPath.addLine(to: CGPoint(x: 121, y: 76))
            bezierPath.addLine(to: CGPoint(x: 124.5, y: 72.38))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 110, y: 52.27))
            bezierPath.addCurve(to: CGPoint(x: 117.88, y: 60.15), controlPoint1: CGPoint(x: 110, y: 56.62), controlPoint2: CGPoint(x: 113.53, y: 60.15))
            bezierPath.addCurve(to: CGPoint(x: 125.77, y: 52.27), controlPoint1: CGPoint(x: 122.24, y: 60.15), controlPoint2: CGPoint(x: 125.77, y: 56.62))
            bezierPath.addCurve(to: CGPoint(x: 110, y: 52.27), controlPoint1: CGPoint(x: 125.77, y: 47), controlPoint2: CGPoint(x: 117.88, y: 52.27))
            bezierPath.close()
            bezierPath.usesEvenOddFillRule = true
            fillColor.setFill()
            bezierPath.fill()
        
            return bezierPath.cgPath
    }
}
