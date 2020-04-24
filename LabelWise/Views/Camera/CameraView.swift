//
// Created by Frank Jia on 2020-04-19.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import SwiftUI
import AVFoundation

// TODO: Loading animation
struct CameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = CameraViewController

    class ViewModel: ObservableObject {
        @Binding var takePicture: Bool
        let onPhotoCapture: PhotoCaptureCallback?

        init(takePicture: Binding<Bool>, onPhotoCapture: PhotoCaptureCallback? = nil) {
            self._takePicture = takePicture
            self.onPhotoCapture = onPhotoCapture
        }
    }
    private let viewModel: ViewModel

    init(vm: ViewModel) {
        self.viewModel = vm
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(onPhotoCapture: self.viewModel.onPhotoCapture)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> CameraViewController {
        let vc = CameraViewController()
        vc.photoCaptureDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: CameraView.UIViewControllerType,
                                context: UIViewControllerRepresentableContext<CameraView>) {
        if self.viewModel.takePicture {
            print("Take pic now")
            uiViewController.takePicture()
        }
    }

    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        private let onPhotoCapture: PhotoCaptureCallback?

        init(onPhotoCapture: PhotoCaptureCallback? = nil) {
            self.onPhotoCapture = onPhotoCapture
        }

        public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            self.onPhotoCapture?(photo.toLabelPhoto(), error)
        }
    }

}


class CameraViewController: UIViewController {

    private var cameraController: CameraController? = nil
    var photoCaptureDelegate: AVCapturePhotoCaptureDelegate?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCamera()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.cameraController?.stopSession()
    }

    func takePicture() {
        // TODO: nil check
        if let delegate = self.photoCaptureDelegate {
            self.cameraController?.capturePhoto(delegate: delegate)
        }
    }

    private func loadCamera() {
        let cameraController = CameraController()
        view.contentMode = UIView.ContentMode.scaleAspectFit
        cameraController.startSession { [weak self] err in
            guard err == nil else {
                // TODO: Logging
                return
            }
            guard let v = self?.view else {
                // TODO: logging
                return
            }
            if let err = cameraController.displayPreview(on: v) {
                print(err)
            }
        }
        self.cameraController = cameraController
    }
}
