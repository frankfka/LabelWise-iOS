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
        @Published var takePicture: Bool = false // Indicates if we are taking a picture. Image is first captured when this is toggled
        @Published var capturedImage: LabelImage? = nil
        @Published var viewState: ViewModel.ViewState = .takePhoto
        // Label types (nutrition/ingredients)
        @Published var selectedLabelTypeIndex: Int = 0
        let labelTypes: [AnalyzeType] = AnalyzeType.allCases
        // Errors
        @Published var cameraError: AppError? = nil
        @Published var analysisError: AppError? = nil
        // Services
        private let labelAnalysisService = LabelAnalysisService() // TODO: dep injection
        private var disposables = Set<AnyCancellable>() // TODO: just have 1, because there is only 1 call here
        @Published var tempCaloriesString: String = "None"

        // Cancel any in-flight actions
        deinit {
            AppLogging.debug("Deinit LabelScannerViewModel")
            disposables.removeAll()
        }

        // View Actions
        func onCapturedImageConfirmed() {
            guard let imageToAnalyze = capturedImage else {
                AppLogging.warn("Captured image is nil but an image was confirmed")
                return
            }
            self.tempCaloriesString = "Loading"
            self.labelAnalysisService.analyzeNutrition(base64Image: imageToAnalyze.compressedB64String)
            .sink(receiveCompletion: { [weak self] completion in
                if let err = completion.getError() {
                    self?.analysisError = err
                    self?.tempCaloriesString = "Error from API"
                }
            }, receiveValue: { [weak self] response in
                print(response.parsedNutrition.calories ?? "None")
                self?.tempCaloriesString = "\(response.parsedNutrition.calories ?? 0)"
            })
            .store(in: &disposables)
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
        case takePhoto
        case confirmPhoto
        case analyzing
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
