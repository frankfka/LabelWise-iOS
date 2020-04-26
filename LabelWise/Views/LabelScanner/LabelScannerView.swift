//
// Created by Frank Jia on 2020-04-18.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import SwiftUI
import Combine
import AVFoundation

// MARK: View Model
extension LabelScannerView {
    class ViewModel: ObservableObject {
        @Published var takePicture: Bool = false
        @Published var isTakingPicture: Bool = false
        @Published var capturedImage: LabelImage? = nil
        @Published var viewMode: ViewModel.ViewMode = .takePhoto
        @Published var selectedLabelTypeIndex: Int = 0 // TODO bundle this with type picker vm

        // Errors
        @Published var cameraError: AppError? = nil
    }
}
extension LabelScannerView.ViewModel {
    enum ViewMode {
        case takePhoto
        case confirmPhoto
    }
    // TODO: This should come from model
    enum LabelTypes: String, CaseIterable {
        case nutrition = "Nutrition"
        case ingredients = "Ingredients"
    }

    // For label type picker
    struct LabelTypePickerViewModel: PickerViewModel {
        var selectedIndex: Binding<Int>
        let items: [String] = LabelTypes.allCases.map { $0.rawValue }

        init(selectedIndex: Binding<Int>) {
            self.selectedIndex = selectedIndex
        }
    }
}

// TODO: status bar color
// TODO: Loading and error views
struct LabelScannerView: View {

    @ObservedObject private var viewModel: ViewModel = ViewModel()

    private var labelTypeVm: ViewModel.LabelTypePickerViewModel {
        ViewModel.LabelTypePickerViewModel(selectedIndex: self.$viewModel.selectedLabelTypeIndex)
    }

    private var overlayViewVm: LabelScannerOverlayView.ViewModel {
        return LabelScannerOverlayView.ViewModel(
                viewMode: self.$viewModel.viewMode,
                labelTypePickerVm: labelTypeVm,
                onCapturePhotoTapped: self.onCapturePhotoTapped,
                onConfirmPhotoAction: self.onConfirmPhotoAction
        )
    }
    private var cameraViewVm: CameraView.ViewModel {
        return CameraView.ViewModel(
                takePicture: self.$viewModel.takePicture,
                cameraError: self.$viewModel.cameraError,
                onPhotoCapture: self.onPhotoCapture
        )
    }

    // MARK: Main View
    var body: some View {
        ZStack(alignment: .bottom) {
            getCameraPreviewOrCapturedImageView()
            LabelScannerOverlayView(vm: self.overlayViewVm)
        }
        .edgesIgnoringSafeArea(.vertical)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }

    // MARK: Component views

    // Display the captured image for confirmation, or the camera preview to take a photo
    private func getCameraPreviewOrCapturedImageView() -> some View {
        if let capturedImage = self.viewModel.capturedImage {
            return Image(uiImage: capturedImage.uiImage)
                    .resizable()
                    .aspectRatio(capturedImage.uiImage.size, contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .eraseToAnyView()
        } else {
            return CameraView(vm: self.cameraViewVm).eraseToAnyView()
        }
    }

    // MARK: Callbacks
    private func onCapturePhotoTapped() {
        if !self.viewModel.isTakingPicture {
            // Take a picture if one isn't in progress
            self.viewModel.takePicture = true
            self.viewModel.isTakingPicture = true
            // TODO: Some loading state
        }
    }

    private func onPhotoCapture(photo: LabelImage?, error: AppError?) {
        self.viewModel.takePicture = false
        self.viewModel.isTakingPicture = false
        if let photo = photo, error == nil {
            if let uiImage = UIImage(data: photo.fullFileData) {
                self.viewModel.capturedImage = photo
                self.viewModel.viewMode = .confirmPhoto
            } else {
                self.viewModel.cameraError = AppError("Unable to convert photo into a UI image")
            }
        } else {
            self.viewModel.cameraError = error
        }
    }

    private func onConfirmPhotoAction(didConfirm: Bool) {
        if didConfirm {
            guard let capturedImage = self.viewModel.capturedImage else {
                // TODO: reset state here to try again
                AppLogging.warn("Captured image is nil when confirming captured image")
                return
            }
            // TODO: somehow analyze, then propagate state to next page
        } else {
            self.viewModel.viewMode = .takePhoto
            self.viewModel.capturedImage = nil
        }
    }

}

struct LabelScannerView_Previews: PreviewProvider {
    static var previews: some View {
        LabelScannerView()
    }
}
