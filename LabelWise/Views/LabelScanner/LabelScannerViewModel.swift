//
// Created by Frank Jia on 2020-04-26.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import Resolver

extension LabelScannerView {
    class ViewModel: StateMachineViewModel<ViewModel.State, ViewModel.Action>, ObservableObject {
        // State machine
        enum State {
            case loadingCamera
            case takePhoto // Before capture tapped
            case takingPhoto  // After capture tapped but before photo comes back
            case confirmingPhoto(image: LabelImage)
            case confirmedPhoto // Terminal state
            case error
        }
        enum Action {
            case cameraInitSuccess
            case cameraInitError(err: AppError)
            case reloadCamera
            case takePhoto
            case takePhotoSuccess(capturedImage: LabelImage)
            case takePhotoError(err: AppError)
            case confirmPhoto
            case cancelPhoto
        }

        // Middleware
        override var middleware: [Middleware<Action>] {
            get {
                [self.loggingMiddleware]
            }
            set {}
        }

        // View-specific attributes
        var takePicture: Bool {
            // Indicates when to take a picture, define setter to allow for binding
            get {
                if case .takingPhoto = self.state {
                    return true
                }
                return false
            }
            set(newVal) {}
        }
        @Injected private var appConfig: AppConfiguration
        // Label types (nutrition/ingredients)
        @Published var selectedLabelTypeIndex: Int = 0
        @Published var showHelpView: Bool = false
        private let labelTypes: [AnalyzeType] = AnalyzeType.allCases
        lazy var displayedLabelTypes: [String] = { labelTypes.map { $0.pickerName } }()
        // Callbacks to propagate certain actions up
        private let onLabelScanned: LabelScannedCallback?

        init(onLabelScanned: LabelScannedCallback? = nil) {
            self.onLabelScanned = onLabelScanned
            super.init(state: .loadingCamera)
        }

        // MARK: State Machine
        override func nextState(for action: Action) -> State? {
            switch state {
            case .loadingCamera:
                switch action {
                case .cameraInitSuccess:
                    return .takePhoto
                case .cameraInitError:
                    return .error
                default: return nil
                }
            case .takePhoto:
                switch action {
                case .takePhoto:
                    return .takingPhoto
                default: return nil
                }
            case .takingPhoto:
                switch action {
                case let .takePhotoSuccess(img):
                    return .confirmingPhoto(image: img)
                case .takePhotoError:
                    return .error
                default: return nil
                }
            case let .confirmingPhoto(img):
                switch action {
                case .confirmPhoto:
                    self.onLabelScanned?(img, self.labelTypes[self.selectedLabelTypeIndex], false)
                    return .confirmedPhoto
                case .cancelPhoto:
                    return .loadingCamera
                default: return nil
                }
            case .error:
                switch action {
                case .reloadCamera:
                    return .loadingCamera
                default: return nil
                }
            case .confirmedPhoto: return nil // Terminal state
            }
        }

        override func enterState(_ state: State) {
            super.enterState(state)
            self.objectWillChange.send() // This allows views to reload whenever state is changed
        }

        // MARK: Middleware
        private var loggingMiddleware: Middleware<Action> {
            AppMiddleware.getLoggingMiddleware(state: self.state, getErr: { action in
                switch action {
                case let .takePhotoError(err), let .cameraInitError(err):
                    return err
                default:
                    return nil
                }
            })
        }
    }
}
// MARK: View Actions
extension LabelScannerView.ViewModel {
    func onViewAppear() {
        // Set the status bar color to light
        UIApplication.setStatusBarStyle(.lightContent)
    }
    func onViewDisappear() {
        // Reset status bar color
        UIApplication.setStatusBarStyle(.default)
    }
    // Called when header help icon is tapped
    func onHelpIconTapped() {
        self.showHelpView = true
    }
    func onHelpViewDismiss() {
        self.showHelpView = false
    }
    func onHelpIconLongHold() {
        if appConfig.isDebug {
            self.onLabelScanned?(PreviewImages.nutritionLabelImage, self.labelTypes[self.selectedLabelTypeIndex], true)
        }
    }

    // Called when camera preview is active
    func onCameraInitialized() {
        self.send(.cameraInitSuccess)
    }
    // Called when any error occurs, either during init or capture
    func onCameraError(_ err: AppError?) {
        self.send(.cameraInitError(err: err ?? AppError("Camera error")))
    }
    // Called when user tries again after an error occurs
    func onErrorTryAgainTapped() {
        self.send(.reloadCamera)
    }
    // Called when camera capture icon is tapped
    func onCapturePhotoTapped() {
        self.send(.takePhoto)
    }
    // Callback when photo is complete
    func onPhotoCapture(photo: LabelImage?, error: AppError?) {
        if let photo = photo, error == nil {
            self.send(.takePhotoSuccess(capturedImage: photo))
        } else {
            self.send(.takePhotoError(err: error ?? AppError("Error taking photo", wrappedError: error)))
        }
    }
    // Photo confirmed,
    func onConfirmPhotoAction(didConfirm: Bool) {
        if didConfirm {
            self.send(.confirmPhoto)
        } else {
            self.send(.cancelPhoto)
        }
    }
}
// MARK: Additional models
extension LabelScannerView.ViewModel {
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
// MARK: Helper extensions
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
