//
//  LabelScannerOverlayFooterView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-19.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// MARK: View Model
extension LabelScannerOverlayFooterView {
    struct ViewModel {
        let onCapturePhotoTapped: VoidCallback?
        let onConfirmPhotoAction: BoolCallback?
        var labelTypePickerVm: PickerViewModel
        @Binding private var viewState: LabelScannerView.ViewModel.ViewState
        var showConfirmPhotoActions: Bool {
            viewState == .confirmPhoto
        }
        var disableActions: Bool {
            viewState == .error || viewState == .loadingCamera || viewState == .takingPhoto
        }

        init(viewState: Binding<LabelScannerView.ViewModel.ViewState>, labelTypePickerVm: PickerViewModel,
             onCapturePhotoTapped: VoidCallback? = nil, onConfirmPhotoAction: BoolCallback? = nil) {
            self._viewState = viewState
            self.labelTypePickerVm = labelTypePickerVm
            self.onCapturePhotoTapped = onCapturePhotoTapped
            self.onConfirmPhotoAction = onConfirmPhotoAction
        }
    }
}

// MARK: View
struct LabelScannerOverlayFooterView: View {
    private static let ActionIconHeight: CGFloat = CGFloat.App.Icon.LargeIcon
    private static let ViewPadding: CGFloat = CGFloat.App.Layout.largePadding
    private static let PickerXPadding: CGFloat = CGFloat.App.Layout.largePadding
    private static let PickerYPadding: CGFloat = CGFloat.App.Layout.normalPadding

    private let viewModel: ViewModel
    private var extraBottomPadding: CGFloat {
        UIApplication.hasNotch ? CGFloat.App.Layout.smallPadding : 0
    }

    init(vm: ViewModel) {
        self.viewModel = vm
    }

    var body: some View {
        VStack {
            // Type picker
            SegmentedPicker(vm: self.viewModel.labelTypePickerVm)
                .padding(.horizontal, LabelScannerOverlayFooterView.PickerXPadding)
                .padding(.bottom, LabelScannerOverlayFooterView.PickerYPadding)
            // Action icons
            VStack {
                if self.viewModel.showConfirmPhotoActions {
                    PhotoActionIcons(
                        isDisabled: self.viewModel.disableActions,
                        onConfirmPhotoAction: self.viewModel.onConfirmPhotoAction
                    )
                } else {
                    CaptureIcon(
                        isDisabled: self.viewModel.disableActions,
                        onTap: self.viewModel.onCapturePhotoTapped
                    )
                }
            }
            .frame(height: LabelScannerOverlayFooterView.ActionIconHeight)
            .fillWidth()
        }
        .padding(.bottom, self.extraBottomPadding)
        .padding(LabelScannerOverlayFooterView.ViewPadding)
        .fillWidth()
        .background(LabelScannerOverlayView.OverlayColor)
    }
    
}

struct LabelScannerOverlayFooterView_Previews: PreviewProvider {
    static let labelTypePickerVm = LabelScannerView.ViewModel.LabelTypePickerViewModel(selectedIndex: .constant(0), items: AnalyzeType.allCases.map { $0.pickerName })
    static let vm = LabelScannerOverlayFooterView.ViewModel(viewState: .constant(.takePhoto), labelTypePickerVm: labelTypePickerVm)
    static var previews: some View {
        LabelScannerOverlayFooterView(vm: vm)
    }
}
