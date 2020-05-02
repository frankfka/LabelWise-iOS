//
// Created by Frank Jia on 2020-04-27.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI

// TODO: Comment this class
// TODO: fix cancel icon color
// TODO: Button color instead of white?
struct RingedIconModifier: ViewModifier {
    // Standard sizes
    private static let StandardButtonSize: CGFloat = CGFloat.App.Icon.largeButton
    private static let StandardDisabledColor: Color = Color.App.Disabled

    // Button Tap Animations
    private static let ButtonAnimationDuration: Double = 0.1
    private static let ButtonTapPressedAnimation: Animation = Animation.easeInOut(duration: ButtonAnimationDuration / 2)
    private static let ButtonTapReleasedAnimation: Animation = ButtonTapPressedAnimation.delay(ButtonAnimationDuration / 2)
    private static let ButtonTapInnerRingScale: CGFloat = 0.95
    @State private var isAnimatingButtonTap: Bool = false

    private let buttonColor: Color
    private let activeRingColor: Color
    private let disabledRingColor: Color
    private let isDisabled: Bool
    private var ringColor: Color {
        isDisabled ? disabledRingColor : activeRingColor
    }
    private let buttonSize: CGFloat
    private let onTapCallback: VoidCallback?

    init(buttonColor: Color, activeRingColor: Color, disabledRingColor: Color = RingedIconModifier.StandardDisabledColor,
         isDisabled: Bool, buttonSize: CGFloat = RingedIconModifier.StandardButtonSize, onTapCallback: VoidCallback? = nil) {
        self.buttonColor = buttonColor
        self.activeRingColor = activeRingColor
        self.disabledRingColor = disabledRingColor
        self.isDisabled = isDisabled
        self.buttonSize = buttonSize
        self.onTapCallback = onTapCallback
    }

    func body(content: Content) -> some View {
        ZStack {
            // Outer ring
            Circle()
                .foregroundColor(buttonColor)
                .frame(width: buttonSize, height: buttonSize)
            // Inner ring
            Circle()
                .foregroundColor(ringColor)
                .frame(width: buttonSize * 0.9, height: buttonSize * 0.9)
            // Center image/circle
            content
                .frame(width: buttonSize * 0.9 * 0.9, height: buttonSize * 0.9 * 0.9)
                .foregroundColor(buttonColor)
                .scaleEffect(isAnimatingButtonTap ? RingedIconModifier.ButtonTapInnerRingScale : 1)
        }
        .contentShape(Circle())
        .onTapGesture(perform: self.onTap)
        .disabled(self.isDisabled)
    }

    private func onTap() {
        if !self.isDisabled {
            self.animateButtonTap()
            // Fire the actual action a bit after the animation
            DispatchQueue.main.asyncAfter(deadline: .now() + RingedIconModifier.ButtonAnimationDuration) {
                self.onTapCallback?()
            }
        }
    }

    private func animateButtonTap() {
        withAnimation(RingedIconModifier.ButtonTapPressedAnimation) {
            self.isAnimatingButtonTap = true
        }
        withAnimation(RingedIconModifier.ButtonTapReleasedAnimation) {
            self.isAnimatingButtonTap = false
        }
    }
}

// Circular icon to take picture
struct CaptureIcon: View {
    private static let ButtonColor: Color = Color.App.White
    private static let ActiveRingColor: Color = Color.App.Primary

    private let onTapCallback: VoidCallback?
    private let isDisabled: Bool

    init(isDisabled: Bool, onTap: VoidCallback? = nil) {
        self.onTapCallback = onTap
        self.isDisabled = isDisabled
    }

    var body: some View {
        Circle()
            .modifier(RingedIconModifier(
                    buttonColor: CaptureIcon.ButtonColor,
                    activeRingColor: CaptureIcon.ActiveRingColor,
                    isDisabled: self.isDisabled,
                    onTapCallback: self.onTapCallback))
    }
}

// Confirm/cancel current photo
struct PhotoActionIcons: View {
    private static let ConfirmIcon: Image = Image.App.CheckmarkCircleFill
    private static let CancelIcon: Image = Image.App.XMarkCircleFill
    private static let ButtonSpacing: CGFloat = CGFloat.App.Layout.extraLargePadding
    private static let ButtonColor: Color = Color.App.White
    private static let ConfirmRingColor: Color = Color.App.Affirmative
    private static let CancelRingColor: Color = Color.App.Destructive
    private let onConfirmPhotoAction: BoolCallback?
    private let isDisabled: Bool

    init(isDisabled: Bool, onConfirmPhotoAction: BoolCallback? = nil) {
        self.isDisabled = isDisabled
        self.onConfirmPhotoAction = onConfirmPhotoAction
    }

    var body: some View {
        HStack(spacing: PhotoActionIcons.ButtonSpacing) {
            getIcon(isConfirm: false)
            getIcon(isConfirm: true)
        }
    }

    private func getIcon(isConfirm: Bool) -> some View {
        let image = isConfirm ? PhotoActionIcons.ConfirmIcon : PhotoActionIcons.CancelIcon
        let activeRingColor: Color = isConfirm ? PhotoActionIcons.ConfirmRingColor : PhotoActionIcons.CancelRingColor
        return image
                .resizable()
                .contentShape(Circle())
                .modifier(RingedIconModifier(
                        buttonColor: PhotoActionIcons.ButtonColor,
                        activeRingColor: activeRingColor,
                        isDisabled: self.isDisabled,
                        onTapCallback: { self.onConfirmPhotoAction?(isConfirm) }))
    }
}

struct LabelScannerActionButtons_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Group {
                // Capture icon
                CaptureIcon(isDisabled: true)
                CaptureIcon(isDisabled: false)
                // Action Icons
                PhotoActionIcons(isDisabled: true)
                PhotoActionIcons(isDisabled: false)
            }
            Group {
                // Capture icon
                CaptureIcon(isDisabled: true)
                CaptureIcon(isDisabled: false)
                // Action Icons
                PhotoActionIcons(isDisabled: true)
                PhotoActionIcons(isDisabled: false)
            }.environment(\.colorScheme, .dark)
            // TODO: Helper for dark color scheme
        }
        .background(Color.App.Overlay)
        .previewLayout(.sizeThatFits)
    }
}
