//
//  PercentageRing.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-27.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct PercentageRing: View {
    
    private static let ShadowColor: Color = Color.App.Shadow
    private static let ShadowRadius: CGFloat = CGFloat.App.Layout.ShadowRadius
    private static let ShadowOffsetMultiplier: CGFloat = ShadowRadius + 2
    private static let AnimationDuration: Double = 1

    // Used for animations
    @State private var displayedPercent: Double = 0
    @State private var gradientAndEndCircleOpacity: Double = 0

    // All calculations are done with percent, not the animated displayPercent
    private let ringWidth: CGFloat
    private let percent: Double
    private let backgroundColor: Color
    private let foregroundColors: [Color]
    private let startAngle: Double = -90
    private var absolutePercentageAngle: Double {
        Ring.percentToAngle(percent: self.percent, startAngle: 0)
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
    private var gradientStartAngle: Double {
        self.percent >= 100 ? relativePercentageAngle - 360 : startAngle
    }
    private var gradientEndAngle: Double {
        self.percent >= 100 ? relativePercentageAngle : startAngle + 360
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
    
    init(percent: Double, ringWidth: CGFloat, backgroundColor: Color, foregroundColors: [Color]) {
        self.ringWidth = ringWidth
        self.percent = percent
        self.backgroundColor = backgroundColor
        self.foregroundColors = foregroundColors
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background for the ring
                Ring()
                    .stroke(style: StrokeStyle(lineWidth: self.ringWidth))
                    .fill(self.backgroundColor)
                // Foreground - this is the start color displayed immediately
                Ring(percent: self.displayedPercent, startAngle: self.startAngle, drawnClockwise: false)
                        .stroke(style: StrokeStyle(lineWidth: self.ringWidth, lineCap: .round))
                        .fill(self.firstGradientColor)
                // Foreground - this is the gradient color that we display after a certain time
                // This is somewhat of a workaround for a nice animation to run
                Ring(percent: self.displayedPercent, startAngle: self.startAngle, drawnClockwise: false)
                    .stroke(style: StrokeStyle(lineWidth: self.ringWidth, lineCap: .round))
                    .fill(self.ringGradient)
                    .opacity(self.gradientAndEndCircleOpacity)
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
                        .opacity(self.gradientAndEndCircleOpacity)
                }
            }
        }
        // Padding to ensure that the entire ring fits within the view size allocated
        .padding(self.ringWidth / 2)
        .onAppear {
            self.runOnAppearAnimation()
        }
    }

    // Animation for onAppear
    private func runOnAppearAnimation(duration: Double = PercentageRing.AnimationDuration) {
        self.displayedPercent = percent
        self.gradientAndEndCircleOpacity = 1
        // TODO: Need to fix this animation, makes scrollview onAppear very weird
        // Instead of using withAnimation, consider using some sort of timer to increment values to the final percent
//        withAnimation(.easeInOut(duration: duration)) {
//            self.displayedPercent = percent
//        }
//        withAnimation(Animation.easeInOut(duration: duration / 2).delay(duration / 2)) {
//            self.gradientAndEndCircleOpacity = 1
//        }
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
                percent: 180, ringWidth: 50,
                backgroundColor: Color.green.opacity(0.2),
                foregroundColors: [.green, .blue]
            )
        }
        .frame(width: 300, height: 300)
        .previewLayout(.sizeThatFits)
    }
}
