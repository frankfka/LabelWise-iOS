//
//  LoadingIndicator.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-02.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI
import Combine

struct LoadingIndicator: View {
    private static let PlaceholderRingColor: Color = Color.App.PrimaryFillColor
    private static let RingWidth: CGFloat = 16
    private static let RingColors: [Color] = [Color.App.AppGreen, Color.App.AppBlue, Color.App.AppPurple,
                                                Color.App.AppRed, Color.App.AppYellow]
    private static let AnimationDuration: Double = 4
    
    // Animated properties
    private var color: Color { LoadingIndicator.RingColors[colorIndex] }
    @State private var opacity: Double = 0.4
    @State private var colorIndex: Int = 0
    @State private var indicatorFillPercent: Double = 0
    @State private var indicatorStartAngle: Double = -90
    @State private var drawnClockwise: Bool = false
    // Timer to manually animate color changes, as it is not supported with repeating animations
    private let colorAnimationTimer: Publishers.Autoconnect<Timer.TimerPublisher> =
            Timer.publish(every: LoadingIndicator.AnimationDuration, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Bottom ring as placeholder
            Ring()
                .stroke(style: StrokeStyle(lineWidth: LoadingIndicator.RingWidth))
                .fill(LoadingIndicator.PlaceholderRingColor)
            // Top ring for animation
            Ring(percent: indicatorFillPercent, startAngle: indicatorStartAngle, drawnClockwise: drawnClockwise)
                .stroke(style: StrokeStyle(lineWidth: LoadingIndicator.RingWidth, lineCap: .round))
                .fill(self.color)
                .opacity(self.opacity)
                .onAppear {
                    self.beginAnimation()
                }
                .onReceive(self.colorAnimationTimer, perform: { _ in
                    self.rotateColors()
                })
        }
        .padding(LoadingIndicator.RingWidth / 2)
    }
    
    // Begin the view animations
    private func beginAnimation() {
        withAnimation(Animation.easeInOut(duration: LoadingIndicator.AnimationDuration / 2).repeatForever(autoreverses: true)) {
            self.opacity = 1
            self.indicatorFillPercent = 100
            self.indicatorStartAngle = 270
            self.drawnClockwise = true
        }
    }
    
    // Change colors every time the timer publishes
    private func rotateColors() {
        if self.colorIndex == LoadingIndicator.RingColors.count - 1 {
            // Restart at first element
            self.colorIndex = 0
        } else {
            self.colorIndex += 1
        }
    }
    
}

struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ColorSchemePreview {
            Group {
                LoadingIndicator()
            }
            .padding()
            .background(Color.App.BackgroundPrimaryFillColor)
        }
        .frame(width: 200, height: 200)
        .previewLayout(.sizeThatFits)
    }
}
