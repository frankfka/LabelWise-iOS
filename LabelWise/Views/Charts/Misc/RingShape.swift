//
//  RingShape.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-27.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// https://liquidcoder.com/swiftui-ring-animation/
struct RingShape: Shape {
    static func percentToAngle(percent: Double, startAngle: Double) -> Double {
        (percent / 100 * 360) + startAngle
    }
    private var percent: Double
    private var startAngle: Double
    
    // This allows animations to run smoothly for percent values
    var animatableData: Double {
        get {
            return percent
        }
        set {
            percent = newValue
        }
    }
    
    init(percent: Double = 100, startAngle: Double = -90) {
        self.percent = percent
        self.startAngle = startAngle
    }
    
    
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let radius = min(width, height) / 2
        let center = CGPoint(x: width / 2, y: height / 2)
        let endAngle = Angle(degrees: RingShape.percentToAngle(percent: self.percent, startAngle: self.startAngle))
        return Path { path in
            path.addArc(center: center, radius: radius, startAngle: Angle(degrees: startAngle) , endAngle: endAngle, clockwise: false)
        }
    }
}
