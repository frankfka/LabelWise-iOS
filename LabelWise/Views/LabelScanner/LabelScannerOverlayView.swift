//
// Created by Frank Jia on 2020-04-18.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct LabelScannerOverlayView: View {
    private static let ViewFinderCornerRadius: CGFloat = 24
    static let OverlayColor = Color.black.opacity(0.8)

    var body: some View {
        VStack(spacing: 0) {
            // Header
            LabelScannerOverlayHeaderView()
            // Camera overlay with hole for full camera view
            GeometryReader { geometry in
                // Rectangle with viewfinder cut-out
                Rectangle()
                    .fill(LabelScannerOverlayView.OverlayColor)
                    .mask(
                        self.getViewFinderMask(parentSize: geometry.size)
                            // eoFill allows cutout
                            .fill(style: FillStyle(eoFill: true, antialiased: true))
                    )
            }
            // Footer
            LabelScannerOverlayFooterView()
        }
    }

    // Get mask (rounded rectangle cutout)
    private func getViewFinderMask(parentSize: CGSize) -> Path {
        // Full rectangle to fill parent
        let parentRect = CGRect(x: 0, y: 0, width: parentSize.width, height: parentSize.height)
        // Get cutout with padding
        let cutoutRect = CGRect(x: parentSize.width * 0.1, y: 0, width: parentSize.width * 0.8, height: parentSize.height)
        var shape = Rectangle().path(in: parentRect)
        shape.addPath(RoundedRectangle(cornerRadius: LabelScannerOverlayView.ViewFinderCornerRadius).path(in: cutoutRect))
        return shape
    }
}
