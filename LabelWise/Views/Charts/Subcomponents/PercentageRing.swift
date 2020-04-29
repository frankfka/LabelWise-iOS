//
//  PercentageRing.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-27.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

extension Double {
    func toRadians() -> Double {
        return self * Double.pi / 180
    }
    func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
}

struct PercentageRing: View {
    
    private static let ShadowColor: Color = Color.black.opacity(0.2)
    private static let ShadowRadius: CGFloat = 5
    private static let ShadowOffsetMultiplier: CGFloat = ShadowRadius + 2
    
    private let ringWidth: CGFloat
    @Binding private var percent: Double
    private let backgroundColor: Color
    private let foregroundColors: [Color]
    private let startAngle: Double = -90
    private var gradientStartAngle: Double {
        self.percent >= 100 ? relativePercentageAngle - 360 : startAngle
    }
    private var gradientEndAngle: Double {
        self.percent >= 100 ? relativePercentageAngle : startAngle + 360
    }
    private var absolutePercentageAngle: Double {
        RingShape.percentToAngle(percent: self.percent, startAngle: 0)
    }
    private var relativePercentageAngle: Double {
        // Take into account the startAngle
        absolutePercentageAngle + startAngle
    }
    private var firstGradientColor: Color {
        self.foregroundColors.first ?? .black
    }
    private var lastGradientColor: Color {
        self.foregroundColors.last ?? .black
    }
    private var ringGradient: AngularGradient {
        AngularGradient(
            gradient: Gradient(colors: self.foregroundColors),
            center: .center,
            startAngle: Angle(degrees: self.gradientStartAngle),
            endAngle: Angle(degrees: self.gradientEndAngle)
        )
    }
    private var endCircleShadowOffset: (CGFloat, CGFloat) {
        let angleForOffset = absolutePercentageAngle + (self.startAngle + 90)
        let angleForOffsetInRadians = angleForOffset.toRadians()
        let relativeXOffset = cos(angleForOffsetInRadians)
        let relativeYOffset = sin(angleForOffsetInRadians)
        let xOffset = relativeXOffset.toCGFloat() * PercentageRing.ShadowOffsetMultiplier
        let yOffset = relativeYOffset.toCGFloat() * PercentageRing.ShadowOffsetMultiplier
        return (xOffset, yOffset)
    }
    
    init(percent: Binding<Double>, ringWidth: CGFloat, backgroundColor: Color, foregroundColors: [Color]) {
        self.ringWidth = ringWidth
        self._percent = percent
        self.backgroundColor = backgroundColor
        self.foregroundColors = foregroundColors
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background for the ring
                RingShape()
                    .stroke(style: StrokeStyle(lineWidth: self.ringWidth))
                    .fill(self.backgroundColor)
                // Foreground
                RingShape(percent: self.percent, startAngle: self.startAngle)
                    .stroke(style: StrokeStyle(lineWidth: self.ringWidth, lineCap: .round))
                    .fill(self.ringGradient)
                // Beginning of ring to cover the gradient cutoff
                if !self.doesRingOverlap(frame: geometry.size) {
                    Circle()
                        .fill(self.firstGradientColor)
                        .frame(width: self.ringWidth, height: self.ringWidth, alignment: .center)
                        .offset(x: self.getStartCircleLocation(frame: geometry.size).0,
                                y: self.getStartCircleLocation(frame: geometry.size).1)
                }
                // End of ring with drop shadow
                if self.doesRingOverlap(frame: geometry.size) {
                    Circle()
                        .fill(self.lastGradientColor)
                        .frame(width: self.ringWidth, height: self.ringWidth, alignment: .center)
                        .offset(x: self.getEndCircleLocation(frame: geometry.size).0,
                                y: self.getEndCircleLocation(frame: geometry.size).1)
                        .shadow(color: PercentageRing.ShadowColor,
                                radius: PercentageRing.ShadowRadius,
                                x: self.endCircleShadowOffset.0,
                                y: self.endCircleShadowOffset.1)
                }
            }
        }
        // Padding to ensure that the entire ring fits within the view size allocated
        .padding(self.ringWidth / 2)
    }
    
    // Returns (x, y) location of the start of the arc
    private func getStartCircleLocation(frame: CGSize) -> (CGFloat, CGFloat) {
        let angleOfStartInRadians: Double = self.startAngle.toRadians()
        let offsetRadius = min(frame.width, frame.height) / 2
        return (offsetRadius * cos(angleOfStartInRadians).toCGFloat(), offsetRadius * sin(angleOfStartInRadians).toCGFloat())
    }

    // Returns (x, y) location of the end of the arc
    private func getEndCircleLocation(frame: CGSize) -> (CGFloat, CGFloat) {
        // Get angle of the end circle with respect to the start angle
        let angleOfEndInRadians: Double = relativePercentageAngle.toRadians()
        let offsetRadius = min(frame.width, frame.height) / 2
        return (offsetRadius * cos(angleOfEndInRadians).toCGFloat(), offsetRadius * sin(angleOfEndInRadians).toCGFloat())
    }
    
    // Determines whether the ring overlaps with itself using the ring width to calculate arc length
    private func doesRingOverlap(frame: CGSize) -> Bool {
        print("called")
        let circleRadius = min(frame.width, frame.height) / 2
        let remainingAngleInRadians = (360 - absolutePercentageAngle).toRadians().toCGFloat()
        if self.percent >= 100 {
            return true
        } else if circleRadius * remainingAngleInRadians <= self.ringWidth {
            return true
        }
        return false
    }
    
}

struct PercentageRing_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PercentageRing(
                percent: .constant(150), ringWidth: 50,
                backgroundColor: Color.green.opacity(0.2),
                foregroundColors: [.green, .blue]
            )
        }
        .frame(width: 300, height: 300)
        .previewLayout(.sizeThatFits)
    }
}
