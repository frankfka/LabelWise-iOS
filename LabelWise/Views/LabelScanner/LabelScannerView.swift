//
// Created by Frank Jia on 2020-04-18.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import SwiftUI
import Combine
import AVFoundation

// TODO: Loading and error views
// TODO: should check for camera permission, then pop to onboarding if it was turned off
struct LabelScannerView: View {

    @ObservedObject private var viewModel: ViewModel
    // Child view view models
    private var labelTypeVm: ViewModel.LabelTypePickerViewModel {
        ViewModel.LabelTypePickerViewModel(
                selectedIndex: self.$viewModel.selectedLabelTypeIndex,
                items: self.viewModel.labelTypes.map {
                    $0.getPickerName()
                })
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
                cameraError: self.$viewModel.cameraError,
                onPhotoCapture: self.viewModel.onPhotoCapture
        )
    }

    init(vm: ViewModel) {
        self.viewModel = vm
    }

    // MARK: Main View
    var body: some View {
        ZStack(alignment: .bottom) {
            getCameraPreviewOrCapturedImageView()
            LabelScannerOverlayView(vm: self.overlayViewVm)
        }
        // Note: Extra padding is applied in overlay header & footer views
        .edgesIgnoringSafeArea(.all)
        .fillWidthAndHeight()
        .onAppear(perform: self.onAppear)
        .onDisappear(perform: self.onDisappear)
    }

    // MARK: Component views

    // Display the captured image for confirmation, or the camera preview to take a photo
    private func getCameraPreviewOrCapturedImageView() -> some View {
        if let capturedImage = self.viewModel.capturedImage {
            return Image(uiImage: capturedImage.uiImage)
                    .resizable()
                    .aspectRatio(capturedImage.uiImage.size, contentMode: .fill)
                    .fillWidthAndHeight()
                    .eraseToAnyView()
        } else {
            return CameraView(vm: self.cameraViewVm).eraseToAnyView()
        }
    }
    
    // MARK: Actions
    private func onAppear() {
        // Set the status bar color to light
        UIApplication.setStatusBarTextColor(showDarkText: false)
    }

    private func onDisappear() {
        // Reset status bar color
        UIApplication.setStatusBarTextColor(showDarkText: nil)
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
