//
// Created by Frank Jia on 2020-04-18.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import SwiftUI
import Combine
import AVFoundation

struct LabelScannerView: View {

    @ObservedObject private var viewModel: ViewModel

    init(vm: ViewModel) {
        self.viewModel = vm
    }

    // Child view view models
    private var labelTypeVm: ViewModel.LabelTypePickerViewModel {
        ViewModel.LabelTypePickerViewModel(
            selectedIndex: self.$viewModel.selectedLabelTypeIndex,
            items: self.viewModel.displayedLabelTypes
        )
    }
    private var overlayViewVm: LabelScannerOverlayView.ViewModel {
        return LabelScannerOverlayView.ViewModel(
            viewMode: self.$viewModel.viewState,
            labelTypePickerVm: labelTypeVm,
            onCapturePhotoTapped: self.viewModel.onCapturePhotoTapped,
            onConfirmPhotoAction: self.viewModel.onConfirmPhotoAction
        )
    }
    private var cameraViewVm: CameraView.ViewModel {
        return CameraView.ViewModel(
            takePicture: self.$viewModel.takePicture,
            onCameraInitialized: self.viewModel.onCameraInitialized,
            onCameraError: self.viewModel.onCameraError,
            onPhotoCapture: self.viewModel.onPhotoCapture
        )
    }
    // Child views
    var viewForCurrentState: some View {
        // TODO: Using anyview here, should fix with some sort of state machine
        if self.viewModel.viewState == .confirmPhoto, let capturedImage = self.viewModel.capturedImage {
            return Image(uiImage: capturedImage.uiImage)
                    .resizable()
                    .aspectRatio(capturedImage.uiImage.size, contentMode: .fill)
                    .fillWidthAndHeight()
                    .eraseToAnyView()
        } else if self.viewModel.viewState == .error {
            return FullScreenErrorView(onTryAgainTapped: { print("TODO") } ).eraseToAnyView()
        } else {
            // Default to taking photo
            return CameraView(vm: self.cameraViewVm).eraseToAnyView()
        }
    }

    // MARK: Main View
    var body: some View {
        ZStack(alignment: .bottom) {
            viewForCurrentState
            LabelScannerOverlayView(vm: self.overlayViewVm)
        }
        // Note: Extra padding is applied in overlay header & footer views
        .edgesIgnoringSafeArea(.all)
        .fillWidthAndHeight()
        .onAppear(perform: self.viewModel.onViewAppear)
        .onDisappear(perform: self.viewModel.onViewDisappear)
    }
}

struct LabelScannerView_Previews: PreviewProvider {
    static let vm: LabelScannerView.ViewModel = LabelScannerView.ViewModel()

    static var previews: some View {
        ColorSchemePreview {
            LabelScannerView(vm: vm)
        }
    }
}
