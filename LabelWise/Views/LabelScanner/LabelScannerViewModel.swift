//
// Created by Frank Jia on 2020-04-26.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

extension LabelScannerView {
    class ViewModel: ObservableObject {
        // View Attributes
        // TODO: remove the below, just use state
        @Published var takePicture: Bool = false // Indicates if we are taking a picture. Image is first captured when this is toggled
        @Published var capturedImage: LabelImage? = nil
        @Published var viewState: ViewModel.ViewState = .takePhoto // TODO: start in loading
        // Label types (nutrition/ingredients)
        @Published var selectedLabelTypeIndex: Int = 0
        let labelTypes: [AnalyzeType] = AnalyzeType.allCases
        // Errors
        @Published var cameraError: AppError? = nil

        // Callbacks to propagate certain actions up
        private let onLabelScanned: LabelScannedCallback?

        init(onLabelScanned: LabelScannedCallback? = nil) {
            self.onLabelScanned = onLabelScanned
        }

        // View Actions
        func onCapturedImageConfirmed() {
            guard let imageToAnalyze = capturedImage else {
                AppLogging.warn("Captured image is nil but an image was confirmed")
                return
            }
            self.onLabelScanned?(imageToAnalyze, self.labelTypes[self.selectedLabelTypeIndex])
        }

        // MARK: Actions
        func onCapturePhotoTapped() {
            if !self.takePicture {
                // Take a picture if one isn't in progress
                self.takePicture = true
                // TODO: Some loading state
            } else {
                AppLogging.debug("Attempting to capture photo while current operation is in progress. Skipping")
            }
        }

        func onPhotoCapture(photo: LabelImage?, error: AppError?) {
            if self.capturedImage != nil {
                AppLogging.warn("Overwriting captured image. Look into this!")
            }
            self.takePicture = false
            if let photo = photo, error == nil {
                self.capturedImage = photo
                self.viewState = .confirmPhoto
            } else {
                self.cameraError = error
            }
        }

        func onConfirmPhotoAction(didConfirm: Bool) {
            if didConfirm {
                self.onCapturedImageConfirmed()
            } else {
                self.viewState = .takePhoto
                self.capturedImage = nil
            }
        }
    }
}

// Additional models within the view model
extension LabelScannerView.ViewModel {
    // States of the scanner view
    enum ViewState {
        case loadingCamera
        case takePhoto // Before capture tapped
        case takingPhoto  // After capture tapped but before photo comes back
        case confirmPhoto
        case error
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
