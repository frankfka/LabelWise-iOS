//
// Created by Frank Jia on 2020-04-19.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = CameraViewController

    struct ViewModel {
        @Binding var takePicture: Bool // Signals when to take a picture
        let onCameraInitialized: VoidCallback?
        let onCameraError: ErrorCallback?
        let onPhotoCapture: PhotoCaptureCallback? // Called when we take a photo

        init(takePicture: Binding<Bool>,
             onCameraInitialized: VoidCallback? = nil,
             onCameraError: ErrorCallback? = nil,
             onPhotoCapture: PhotoCaptureCallback? = nil) {
            self._takePicture = takePicture
            self.onCameraInitialized = onCameraInitialized
            self.onCameraError = onCameraError
            self.onPhotoCapture = onPhotoCapture
        }
    }
    private let viewModel: ViewModel

    init(vm: ViewModel) {
        self.viewModel = vm
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(
            onCameraInitialized: self.viewModel.onCameraInitialized,
            onCameraError: self.viewModel.onCameraError,
            onPhotoCapture: self.viewModel.onPhotoCapture
        )
    }

    // Called when the view is shown
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> CameraViewController {
        let vc = CameraViewController()
        vc.coordinator = context.coordinator
        return vc
    }

    // Called on any state change (from view model)
    func updateUIViewController(_ uiViewController: CameraView.UIViewControllerType,
                                context: UIViewControllerRepresentableContext<CameraView>) {
        // Take picture if our state calls for it
        if self.viewModel.takePicture, let err = uiViewController.takePicture() {
            self.viewModel.onCameraError?(err)
        }
    }

    // The coordinator allows the view controller to interact with the state
    // It also serves as the delegate for photo taking
    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        let onCameraInitialized: VoidCallback?
        let onCameraError: ErrorCallback?
        private let onPhotoCapture: PhotoCaptureCallback?

        init(onCameraInitialized: VoidCallback? = nil,
             onCameraError: ErrorCallback? = nil,
             onPhotoCapture: PhotoCaptureCallback? = nil) {
            self.onCameraInitialized = onCameraInitialized
            self.onCameraError = onCameraError
            self.onPhotoCapture = onPhotoCapture
        }

        public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            guard error == nil else {
                self.onPhotoCapture?(nil, AppError("Error taking photo", wrappedError: error))
                return
            }
            let labelPhotoResult = photo.toLabelImage()
            self.onPhotoCapture?(labelPhotoResult.0, labelPhotoResult.1)
        }
    }
}

// Underlying view controller for the camera view
class CameraViewController: UIViewController {

    private var cameraController: CameraController? = nil // This controls all interfacing with the camera
    var coordinator: CameraView.Coordinator? = nil // This allows us to propagate state up

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = .black // Force background color to be black, looks better
        loadCamera()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Important to stop the current camera session
        self.cameraController?.stopSession()
    }

    // Called to take a picture
    func takePicture() -> AppError? {
        guard let coordinator = self.coordinator else {
            return AppError("No photo capture delegate")
        }
        guard let cameraController = self.cameraController else {
            return AppError("No camera controller")
        }
        return cameraController.capturePhoto(delegate: coordinator)
    }

    // Initialize the camera controller
    private func loadCamera() {
        let cameraController = CameraController()
        view.contentMode = UIView.ContentMode.scaleAspectFit
        cameraController.startSession { [weak self] err in
            guard err == nil else {
                self?.coordinator?.onCameraError?(AppError("Error starting camera session", wrappedError: err))
                return
            }
            guard let v = self?.view else {
                self?.coordinator?.onCameraError?(AppError("No view to display preview on"))
                return
            }
            let cameraInitErr = cameraController.displayPreview(on: v)
            guard cameraInitErr == nil else {
                self?.coordinator?.onCameraError?(AppError("Error displaying camera preview", wrappedError: err))
                return
            }
            self?.coordinator?.onCameraInitialized?()
            self?.cameraController = cameraController
        }
    }
}
