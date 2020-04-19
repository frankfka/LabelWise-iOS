//
// Created by Frank Jia on 2020-04-19.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import UIKit
import AVFoundation

// https://medium.com/@gaspard.rosay/create-a-camera-app-with-swiftui-60876fcb9118
class CameraController {

    struct CameraError: Error {
        let message: String
        let wrappedError: Error?

        init(message: String = "", wrappedError: Error? = nil) {
            self.message = message
            self.wrappedError = wrappedError
        }
    }

    private var captureSession: AVCaptureSession?
    private var frontCamera: AVCaptureDevice?
    private var frontCameraInput: AVCaptureDeviceInput?
    private var previewLayer: AVCaptureVideoPreviewLayer?

    func startSession(onComplete: @escaping ErrorCallback) {
        DispatchQueue.main.async {
            onComplete(self.prepareCamera())
        }
    }

    private func prepareCamera() -> CameraError? {
        let captureSession: AVCaptureSession = AVCaptureSession()
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) else {
            return CameraError(message: "No camera available")
        }
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            return CameraError(message: "Cannot create camera input")
        }
        guard captureSession.canAddInput(cameraInput) else {
            return CameraError(message: "Cannot add camera input")
        }
        captureSession.addInput(cameraInput)
        captureSession.startRunning()
        self.captureSession = captureSession
        self.frontCamera = camera
        self.frontCameraInput = cameraInput
        return nil
    }

    func displayPreview(on view: UIView) -> CameraError? {
        guard let captureSession = self.captureSession, captureSession.isRunning else {
            return CameraError(message: "Invalid capture session")
        }

        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait

        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
        return nil
    }

    func stopSession() {
        print("deinit camera")
        self.captureSession?.stopRunning()
    }

}