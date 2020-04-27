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
        @Binding var viewState: LabelScannerView.ViewModel.ViewState

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

    private let viewModel: ViewModel
    init(vm: ViewModel) {
        self.viewModel = vm
    }

    var body: some View {
        VStack {
            LabelTypePickerView(vm: self.viewModel.labelTypePickerVm)
                .padding(.horizontal, CGFloat.App.Layout.largePadding)
                .padding(.bottom, CGFloat.App.Layout.normalPadding)
            if self.viewModel.viewState == .takePhoto {
                CaptureIcon(onTap: self.viewModel.onCapturePhotoTapped)
            } else {
                PhotoActionIcons(onConfirmPhotoAction: self.viewModel.onConfirmPhotoAction)
            }
        }
        .padding(.bottom, CGFloat.App.Layout.largePadding)
        .padding(CGFloat.App.Layout.largePadding)
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(LabelScannerOverlayView.OverlayColor)
    }
    
}

struct LabelScannerOverlayFooterView_Previews: PreviewProvider {
    static let labelTypePickerVm = LabelScannerView.ViewModel.LabelTypePickerViewModel(selectedIndex: .constant(0), items: AnalyzeType.allCases.map { $0.getPickerName() })
    static let vm = LabelScannerOverlayFooterView.ViewModel(viewState: .constant(.takePhoto), labelTypePickerVm: labelTypePickerVm)
    static var previews: some View {
        LabelScannerOverlayFooterView(vm: vm)
    }
}
