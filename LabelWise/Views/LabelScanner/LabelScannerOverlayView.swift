//
// Created by Frank Jia on 2020-04-18.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// MARK: View Model
extension LabelScannerOverlayView {
    struct ViewModel {
        @Binding var viewState: LabelScannerView.ViewModel.ViewState
        var labelTypePickerVm: PickerViewModel
        let onCapturePhotoTapped: VoidCallback?
        let onConfirmPhotoAction: BoolCallback?

        init(viewMode: Binding<LabelScannerView.ViewModel.ViewState>, labelTypePickerVm: PickerViewModel,
             onCapturePhotoTapped: VoidCallback? = nil, onConfirmPhotoAction: BoolCallback? = nil) {
            self._viewState = viewMode
            self.labelTypePickerVm = labelTypePickerVm
            self.onCapturePhotoTapped = onCapturePhotoTapped
            self.onConfirmPhotoAction = onConfirmPhotoAction
        }
    }
}

// MARK: View
struct LabelScannerOverlayView: View {
    private static let ViewFinderCornerRadius: CGFloat = CGFloat.App.Layout.CornerRadius
    private static let ViewFinderRelativeWidth: CGFloat = 0.8
    private static var ViewFinderRelativeWidthPadding: CGFloat {
        (1.0 - ViewFinderRelativeWidth) / 2
    }
    static let OverlayColor = Color.App.Overlay
    private let viewModel: ViewModel
    private var footerViewModel: LabelScannerOverlayFooterView.ViewModel {
        return LabelScannerOverlayFooterView.ViewModel(
            viewState: self.viewModel.$viewState,
            labelTypePickerVm: self.viewModel.labelTypePickerVm,
            onCapturePhotoTapped: self.viewModel.onCapturePhotoTapped,
            onConfirmPhotoAction: self.viewModel.onConfirmPhotoAction
        )
    }
    
    init(vm: ViewModel) {
        self.viewModel = vm
    }
    
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
            LabelScannerOverlayFooterView(vm: self.footerViewModel)
        }
    }
    
    // Get mask (rounded rectangle cutout)
    private func getViewFinderMask(parentSize: CGSize) -> Path {
        // Full rectangle to fill parent
        let parentRect = CGRect(x: 0, y: 0, width: parentSize.width, height: parentSize.height)
        // Get cutout with padding
        let cutoutRect = CGRect(x: parentSize.width * LabelScannerOverlayView.ViewFinderRelativeWidthPadding, y: 0,
                                width: parentSize.width * LabelScannerOverlayView.ViewFinderRelativeWidth, height: parentSize.height)
        var shape = Rectangle().path(in: parentRect)
        shape.addPath(RoundedRectangle(cornerRadius: LabelScannerOverlayView.ViewFinderCornerRadius).path(in: cutoutRect))
        return shape
    }
}

struct LabelScannerOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        // TODO
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
