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
        @Published var capturedImage: LabelImage? = nil
        @Published var viewState: ViewModel.ViewState = .loadingCamera
        var takePicture: Bool {
            // Indicates when to take a picture, define setter to allow for binding
            get { self.viewState == .takingPhoto }
            set(newVal) {}
        }
        // Label types (nutrition/ingredients)
        private let labelTypes: [AnalyzeType] = AnalyzeType.allCases
        @Published var selectedLabelTypeIndex: Int = 0
        lazy var displayedLabelTypes: [String] = { labelTypes.map { $0.pickerName } }()

        // Callbacks to propagate certain actions up
        private let onLabelScanned: LabelScannedCallback?

        init(onLabelScanned: LabelScannedCallback? = nil) {
            self.onLabelScanned = onLabelScanned
        }
    }
}
// MARK: Actions
extension LabelScannerView.ViewModel {
    func onViewAppear() {
        // Set the status bar color to light
        UIApplication.setStatusBarTextColor(showDarkText: false)
    }
    func onViewDisappear() {
        // Reset status bar color
        UIApplication.setStatusBarTextColor(showDarkText: nil)
    }
    func onCameraInitialized() {
        self.viewState = .takePhoto
    }
    func onCameraError(_ err: AppError?) {
        AppLogging.error("Camera error: \(String(describing: err))")
        self.viewState = .error
    }
    // Called when camera capture icon is tapped
    func onCapturePhotoTapped() {
        if self.viewState == .takePhoto {
            // Take a picture if we're in the right state
            self.viewState = .takingPhoto
        } else {
            AppLogging.debug("Attempting to capture photo in an invalid state. Skipping")
        }
    }
    // Callback when photo is complete
    func onPhotoCapture(photo: LabelImage?, error: AppError?) {
        if self.capturedImage != nil {
            AppLogging.error("Overwriting captured image. Look into this!")
        }
        if let photo = photo, error == nil {
            self.viewState = .confirmPhoto
            self.capturedImage = photo
        } else {
            AppLogging.error("Error from camera during capture: \(String(describing: error))")
            self.viewState = .error
        }
    }
    // Photo confirmed,
    func onConfirmPhotoAction(didConfirm: Bool) {
        if didConfirm {
            // Image confirmed, pass the image to callback
            guard let imageToAnalyze = capturedImage else {
                AppLogging.error("Captured image is nil but an image was confirmed")
                self.viewState = .error
                return
            }
            self.onLabelScanned?(imageToAnalyze, self.labelTypes[self.selectedLabelTypeIndex])
        } else {
            self.viewState = .takePhoto
            self.capturedImage = nil
        }
    }
}
// MARK: Additional models
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
    var pickerName: String {
        switch self {
        case .nutrition:
            return "Nutrition"
        case .ingredients:
            return "Ingredients"
        }
    }
}
