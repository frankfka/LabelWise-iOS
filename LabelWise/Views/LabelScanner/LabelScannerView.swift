//
// Created by Frank Jia on 2020-04-18.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import SwiftUI
import AVFoundation

struct LabelScannerView: View {

    @State private var scanLabelTypeIndex: Int = 0 // TODO: use this
    // TODO: need to figure out how to manage the state here
    @State private var takePicture: Bool = false
    @State private var isTakingPicture: Bool = false
    @State private var capturedImage: UIImage? = nil

    private var cameraViewVm: CameraView.ViewModel {
        return CameraView.ViewModel(
                takePicture: self.$takePicture,
                onPhotoCapture: self.onPhotoCapture
        )
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            if capturedImage != nil {
                Image(uiImage: capturedImage!)
                        .resizable()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            } else {
                CameraView(vm: self.cameraViewVm)
            }
            LabelScannerOverlayView(onCapturePhotoTapped: onCapturePhotoTapped)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }

    // MARK: Callbacks
    private func onCapturePhotoTapped() {
        if !isTakingPicture {
            // Take a picture if one isn't in progress
            self.takePicture = true
            self.isTakingPicture = true
        }
    }

    private func onPhotoCapture(photo: LabelPhoto?, error: Error?) {
        print("on photo capture")
        self.takePicture = false
        self.isTakingPicture = false
        if let photo = photo, error == nil {
            if let uiImage = UIImage(data: photo.fileData) {
                print("Done converting")
                self.capturedImage = uiImage
            } else {
                print("error converting")
            }
        } else {
            print(error)
            // TODO: proper logging and error handling
        }
    }

}

struct LabelScannerView_Previews: PreviewProvider {
    static var previews: some View {
        LabelScannerView()
    }
}
