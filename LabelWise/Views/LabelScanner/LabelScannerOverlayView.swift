//
// Created by Frank Jia on 2020-04-18.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// MARK: View Model
extension LabelScannerOverlayView {
    struct ViewModel {
        @Binding var state: LabelScannerView.ViewModel.State
        var labelTypePickerVm: PickerViewModel
        let onHelpIconTapped: VoidCallback?
        let onHelpIconLongHold: VoidCallback?
        let onCapturePhotoTapped: VoidCallback?
        let onConfirmPhotoAction: BoolCallback?

        init(state: Binding<LabelScannerView.ViewModel.State>, labelTypePickerVm: PickerViewModel,
             onHelpIconTapped: VoidCallback? = nil, onHelpIconLongHold: VoidCallback? = nil,
             onCapturePhotoTapped: VoidCallback? = nil, onConfirmPhotoAction: BoolCallback? = nil) {
            self._state = state
            self.labelTypePickerVm = labelTypePickerVm
            self.onHelpIconTapped = onHelpIconTapped
            self.onHelpIconLongHold = onHelpIconLongHold
            self.onCapturePhotoTapped = onCapturePhotoTapped
            self.onConfirmPhotoAction = onConfirmPhotoAction
        }
    }
}

// MARK: View
struct LabelScannerOverlayView: View {
    private static let ViewFinderRelativeWidth: CGFloat = 0.8
    private static var ViewFinderRelativeWidthPadding: CGFloat {
        (1.0 - ViewFinderRelativeWidth) / 2
    }
    static let OverlayColor = Color.App.Overlay
    private let viewModel: ViewModel
    private var footerViewModel: LabelScannerOverlayFooterView.ViewModel {
        return LabelScannerOverlayFooterView.ViewModel(
            state: self.viewModel.$state,
            labelTypePickerVm: self.viewModel.labelTypePickerVm,
            onCapturePhotoTapped: self.viewModel.onCapturePhotoTapped,
            onConfirmPhotoAction: self.viewModel.onConfirmPhotoAction
        )
    }

    init(vm: ViewModel) {
        self.viewModel = vm
    }
    
    var body: some View {
        GeometryReader { outerGeometry in // Outer geometry to read safe area insets
            VStack(spacing: 0) {
                // Header
                LabelScannerOverlayHeaderView(
                    helpIconTappedCallback: self.viewModel.onHelpIconTapped,
                    onHelpIconLongHold: self.viewModel.onHelpIconLongHold
                )
                    .padding(.top, outerGeometry.safeAreaInsets.top)
                    .background(LabelScannerOverlayView.OverlayColor)
                // Camera overlay with hole for full camera view
                GeometryReader { overlayCutoutGeometry in
                    // Rectangle with viewfinder cut-out
                    Rectangle()
                        .fill(LabelScannerOverlayView.OverlayColor)
                        .mask(
                            self.getViewFinderMask(parentSize: overlayCutoutGeometry.size)
                                // eoFill allows cutout
                                .fill(style: FillStyle(eoFill: true, antialiased: true))
                        )
                        .allowsHitTesting(false) // Allow touches to pass through
                }
                // Footer
                LabelScannerOverlayFooterView(vm: self.footerViewModel)
                    .padding(.bottom, outerGeometry.safeAreaInsets.bottom)
                    .background(LabelScannerOverlayView.OverlayColor)
            }
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
        shape.addPath(RoundedRectangle.Standard.path(in: cutoutRect))
        return shape
    }
}

struct LabelScannerOverlayView_Previews: PreviewProvider {

    private static let labelTypePickerVm = LabelScannerView.ViewModel.LabelTypePickerViewModel(selectedIndex: .constant(0), items: AnalyzeType.allCases.map { $0.pickerName })
    private static let vm = LabelScannerOverlayView.ViewModel(state: .constant(.takePhoto), labelTypePickerVm: labelTypePickerVm)

    static var previews: some View {
        LabelScannerOverlayView(vm: vm)
    }
}
