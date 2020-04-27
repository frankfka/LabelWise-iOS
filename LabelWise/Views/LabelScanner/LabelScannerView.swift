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
        @Published var takePicture: Bool = false // Indicates if we are taking a picture. Image is first captured when this is toggled
        @Published var capturedImage: LabelImage? = nil
        @Published var viewState: ViewModel.ViewState = .takePhoto
        // Label types (nutrition/ingredients)
        @Published var selectedLabelTypeIndex: Int = 0
        let labelTypes: [AnalyzeType] = AnalyzeType.allCases

        // Errors
        @Published var cameraError: AppError? = nil
    }
}

extension LabelScannerView.ViewModel {
    enum ViewState {
        case takePhoto
        case confirmPhoto
    }

    // For label type picker
    struct LabelTypePickerViewModel: PickerViewModel {
        var selectedIndex: Binding<Int>
        let items: [String]

        init(selectedIndex: Binding<Int>, items: [String]) {
            self.selectedIndex = selectedIndex
            self.items = items
        }
    }
}

extension AnalyzeType {
    func getPickerName() -> String {
        switch self {
        case .nutrition:
            return "Nutrition"
        case .ingredients:
            return "Ingredients"
        }
    }
}

// TODO: status bar color
// TODO: Loading and error views
// MARK: View
struct LabelScannerView: View {

    @ObservedObject private var viewModel: ViewModel = ViewModel()

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
        if !self.viewModel.takePicture {
            // Take a picture if one isn't in progress
            self.viewModel.takePicture = true
            // TODO: Some loading state
        } else {
            AppLogging.debug("Attempting to capture photo while current operation is in progress. Skipping")
        }
    }

    private func onPhotoCapture(photo: LabelImage?, error: AppError?) {
        // TODO: Do a check that the current photo is nil, this makes sure we dont keep taking pictures
        self.viewModel.takePicture = false
        if let photo = photo, error == nil {
            self.viewModel.capturedImage = photo
            self.viewModel.viewState = .confirmPhoto
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
            self.viewModel.viewState = .takePhoto
            self.viewModel.capturedImage = nil
        }
    }

}

struct LabelScannerView_Previews: PreviewProvider {
    static var previews: some View {
        LabelScannerView()
    }
}
