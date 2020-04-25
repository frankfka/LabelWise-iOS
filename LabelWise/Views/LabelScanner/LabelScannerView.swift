//
// Created by Frank Jia on 2020-04-18.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import SwiftUI
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
    @State private var capturedImage: UIImage? = nil
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
        if let capturedImage = self.capturedImage {
            return Image(uiImage: capturedImage)
                    .resizable()
                    .aspectRatio(capturedImage.size, contentMode: .fill)
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
            if let uiImage = UIImage(data: photo.fileData) {
                self.capturedImage = uiImage
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
            // TODO: Push to some other view
        } else {
            self.viewMode = .takePhoto
            self.capturedImage = nil
        }
    }

}

struct LabelScannerView_Previews: PreviewProvider {
    static var previews: some View {
        LabelScannerView()
    }
}
