//
// Created by Frank Jia on 2020-04-27.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI

// Circular icon to take picture
struct CaptureIcon: View {
    private static let OuterRingSize: CGFloat = CGFloat.App.Icon.largeButton
    private static let DarkOuterRingSize: CGFloat = OuterRingSize * 0.9
    private static let InnerRingSize: CGFloat = DarkOuterRingSize * 0.9
    // Button Tap Animations
    private static let ButtonTapPressedAnimation: Animation = Animation.easeInOut(duration: 0.05)
    private static let ButtonTapReleasedAnimation: Animation = ButtonTapPressedAnimation.delay(0.05)
    private static let ButtonTapInnerRingScale: CGFloat = 0.95
    @State private var isAnimatingButtonTap: Bool = false

    private let onTap: VoidCallback?

    init(onTap: VoidCallback? = nil) {
        self.onTap = onTap
    }

    var body: some View {
        ZStack() {
            Circle()
                .foregroundColor(.white)
                .frame(width: CaptureIcon.OuterRingSize, height: CaptureIcon.OuterRingSize)
            Circle()
                .foregroundColor(.gray)
                .frame(width: CaptureIcon.DarkOuterRingSize, height: CaptureIcon.DarkOuterRingSize)
            Circle()
                .foregroundColor(.white)
                .frame(width: CaptureIcon.InnerRingSize, height: CaptureIcon.InnerRingSize)
                .scaleEffect(self.isAnimatingButtonTap ? CaptureIcon.ButtonTapInnerRingScale : 1)
        }
        .contentShape(Circle())
        .onTapGesture {
            self.animateButtonTap()
            self.onTap?()
        }
    }

    private func animateButtonTap() {
        withAnimation(CaptureIcon.ButtonTapPressedAnimation) {
            self.isAnimatingButtonTap = true
        }
        withAnimation(CaptureIcon.ButtonTapReleasedAnimation) {
            self.isAnimatingButtonTap = false
        }
    }
}

// Confirm/cancel current photo
struct PhotoActionIcons: View {
    private static let ButtonSize: CGFloat = CGFloat.App.Icon.largeButton
    private static let ButtonSpacing: CGFloat = CGFloat.App.Layout.extraLargePadding
    private let onConfirmPhotoAction: BoolCallback?

    init(onConfirmPhotoAction: BoolCallback?) {
        self.onConfirmPhotoAction = onConfirmPhotoAction
    }

    var body: some View {
        HStack(spacing: PhotoActionIcons.ButtonSpacing) {
            getIcon(isConfirm: false)
            getIcon(isConfirm: true)
        }
    }

    private func getIcon(isConfirm: Bool) -> some View {
        let image = isConfirm ? Image.App.labelScannerConfirmImage : Image.App.labelScannerCancelImage
        return image
                .resizable()
                .frame(width: PhotoActionIcons.ButtonSize, height: PhotoActionIcons.ButtonSize)
                .contentShape(Circle())
                .foregroundColor(Color.white)
                .onTapGesture {
                    self.onConfirmPhotoAction?(isConfirm)
                }
    }
}