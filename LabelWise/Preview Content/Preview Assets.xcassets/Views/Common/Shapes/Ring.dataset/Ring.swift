//
//  RingShape.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-27.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// https://liquidcoder.com/swiftui-ring-animation/
struct Ring: Shape {
    // Helper function to convert percent values to angles in degrees
    static func percentToAngle(percent: Double, startAngle: Double) -> Double {
        (percent / 100 * 360) + startAngle
    }
    private var percent: Double
    private var startAngle: Double
    private var drawnClockwise: Bool
    
    struct Animatable {
        let percent: Double
        let startAngle: Double
    }
    
    // This allows animations to run smoothly: (drawnClockwise, (percent, startAngle))
    var animatableData: AnimatablePair<Double, AnimatablePair<Double, Double>> {
        // Animatable requires numerical data
        get {
            return AnimatablePair<Double, AnimatablePair<Double, Double>>(drawnClockwise ? 0 : 1, AnimatablePair<Double, Double>(percent, startAngle))
        }
        set {
            drawnClockwise = newValue.first == 1
            percent = newValue.second.first
            startAngle = newValue.second.second
        }
    }
    
    init(percent: Double = 100, startAngle: Double = -90, drawnClockwise: Bool = false) {
        self.percent = percent
        self.startAngle = startAngle
        self.drawnClockwise = drawnClockwise
    }
    
    // This draws a simple arc from the start angle to the end angle
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let radius = min(width, height) / 2
        let center = CGPoint(x: width / 2, y: height / 2)
        let endAngle = Angle(degrees: Ring.percentToAngle(percent: self.percent, startAngle: self.startAngle))
        return Path { path in
            path.addArc(center: center, radius: radius, startAngle: Angle(degrees: startAngle), endAngle: endAngle, clockwise: drawnClockwise)
        }
    }
}

struct RingShape_Previews: PreviewProvider {
    static var previews: some View {
        Ring(percent: 10, startAngle: 0, drawnClockwise: false)
            .stroke(style: StrokeStyle(lineWidth: 16))
            .fill(Color.black)
            .frame(width: 200, height: 200)
            .previewLayout(.sizeThatFits)
    }
}
