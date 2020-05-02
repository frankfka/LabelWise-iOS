//
// Created by Frank Jia on 2020-04-18.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import SwiftUI
import Combine
import AVFoundation

// TODO: status bar color
// TODO: Loading and error views
// TODO: no padding for non iphone x
struct LabelScannerView: View {

    @ObservedObject private var viewModel: ViewModel = ViewModel()
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

    // MARK: Main View
    var body: some View {
        ZStack(alignment: .bottom) {
            getCameraPreviewOrCapturedImageView()
            LabelScannerOverlayView(vm: self.overlayViewVm)
        }
        .edgesIgnoringSafeArea(.vertical)
        .fillWidthAndHeight()
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
}

struct LabelScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSchemePreview {
            LabelScannerView()
        }
    }
}
