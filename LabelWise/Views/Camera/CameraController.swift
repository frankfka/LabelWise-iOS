//
// Created by Frank Jia on 2020-04-19.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import UIKit
import AVFoundation

// https://medium.com/@gaspard.rosay/create-a-camera-app-with-swiftui-60876fcb9118
class CameraController {

    private var captureSession: AVCaptureSession?
    private var frontCamera: AVCaptureDevice?
    private var frontCameraInput: AVCaptureDeviceInput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var photoOutput: AVCapturePhotoOutput?

    func startSession(onComplete: @escaping ErrorCallback) {
        DispatchQueue.main.async {
            onComplete(self.prepareCamera())
        }
    }

    private func prepareCamera() -> AppError? {
        let captureSession: AVCaptureSession = AVCaptureSession()
        // Get the camera
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) else {
            return AppError("No camera available")
        }
        // Create the input
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            return AppError("Cannot create camera input")
        }
        // Make sure the capture session can use the input
        guard captureSession.canAddInput(cameraInput) else {
            return AppError("Cannot add camera input")
        }
        captureSession.addInput(cameraInput)
        // Configure for photo capture
        captureSession.beginConfiguration()
        let photoOutput = AVCapturePhotoOutput()
        photoOutput.isHighResolutionCaptureEnabled = true
        photoOutput.isLivePhotoCaptureEnabled = false
        // Make sure we can have the specified input
        guard captureSession.canAddOutput(photoOutput) else {
            return AppError("Cannot add photo output")
        }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        captureSession.commitConfiguration()
        // Start the capture session
        captureSession.startRunning()
        self.captureSession = captureSession
        self.frontCamera = camera
        self.frontCameraInput = cameraInput
        self.photoOutput = photoOutput
        return nil
    }

    func displayPreview(on view: UIView) -> AppError? {
        guard let captureSession = self.captureSession, captureSession.isRunning else {
            return AppError("Invalid capture session")
        }

        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait

        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
        return nil
    }

    func stopSession() {
        self.captureSession?.stopRunning()
    }

    func capturePhoto(delegate: AVCapturePhotoCaptureDelegate) -> AppError? {
        guard let photoOutput = self.photoOutput else {
            return AppError("No photo output configured")
        }
        let captureSettings = AVCapturePhotoSettings()
        captureSettings.flashMode = .auto
        photoOutput.capturePhoto(with: captureSettings, delegate: delegate)
        return nil
    }

}