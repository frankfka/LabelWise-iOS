//
// Created by Frank Jia on 2020-04-18.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import SwiftUI
import Combine
import AVFoundation

// TODO: status bar color
// TODO: Loading and error views
struct LabelScannerView: View {

    class ViewModel: ObservableObject {
        struct LabelTypePickerViewModel: PickerViewModel {
            var selectedIndex: Binding<Int>
            let items: [String] = LabelTypes.allCases.map { $0.rawValue }

            init(selectedIndex: Binding<Int>) {
                self.selectedIndex = selectedIndex
            }
        }
        enum ViewMode {
            case takePhoto
            case confirmPhoto
        }
        enum LabelTypes: String, CaseIterable {
            case nutrition = "Nutrition"
            case ingredients = "Ingredients"
        }
    }
    @State private var takePicture: Bool = false
    @State private var isTakingPicture: Bool = false
    @State private var capturedImage: LabelImage? = nil
    // TODO: can remove this now
    @State private var capturedUIImage: UIImage? = nil
    @State private var viewMode: ViewModel.ViewMode = .takePhoto
    @State private var selectedLabelTypeIndex = 0
    @State private var cameraError: AppError?
    private var labelTypeVm: ViewModel.LabelTypePickerViewModel {
        ViewModel.LabelTypePickerViewModel(selectedIndex: self.$selectedLabelTypeIndex)
    }

    private var overlayViewVm: LabelScannerOverlayView.ViewModel {
        return LabelScannerOverlayView.ViewModel(
                viewMode: self.$viewMode,
                labelTypePickerVm: labelTypeVm,
                onCapturePhotoTapped: self.onCapturePhotoTapped,
                onConfirmPhotoAction: self.onConfirmPhotoAction
        )
    }
    private var cameraViewVm: CameraView.ViewModel {
        return CameraView.ViewModel(
                takePicture: self.$takePicture,
                cameraError: self.$cameraError,
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
        if let capturedUIImage = self.capturedUIImage {
            return Image(uiImage: capturedUIImage)
                    .resizable()
                    .aspectRatio(capturedUIImage.size, contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .eraseToAnyView()
        } else {
            return CameraView(vm: self.cameraViewVm).eraseToAnyView()
        }
    }

    // MARK: Callbacks
    private func onCapturePhotoTapped() {
        if !self.isTakingPicture {
            // Take a picture if one isn't in progress
            self.takePicture = true
            self.isTakingPicture = true
            // TODO: Some loading state
        }
    }

    private func onPhotoCapture(photo: LabelImage?, error: AppError?) {
        self.takePicture = false
        self.isTakingPicture = false
        if let photo = photo, error == nil {
            if let uiImage = UIImage(data: photo.fullFileData) {
                self.capturedImage = photo
                self.capturedUIImage = uiImage
                self.viewMode = .confirmPhoto
            } else {
                self.cameraError = AppError("Unable to convert photo into a UI image")
            }
        } else {
            self.cameraError = error
        }
    }

    private func onConfirmPhotoAction(didConfirm: Bool) {
        if didConfirm {
            guard let capturedImage = self.capturedImage else {
                // TODO: reset state here to try again
                AppLogging.warn("Captured image is nil when confirming captured image")
                return
            }
            // TODO: somehow analyze, then propagate state to next page
        } else {
            self.viewMode = .takePhoto
            self.capturedImage = nil
            self.capturedUIImage = nil
        }
    }

}

struct LabelScannerView_Previews: PreviewProvider {
    static var previews: some View {
        LabelScannerView()
    }
}
