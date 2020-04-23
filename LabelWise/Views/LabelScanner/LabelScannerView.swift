//
// Created by Frank Jia on 2020-04-18.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import SwiftUI
import AVFoundation

// TODO: status bar color
struct LabelScannerView: View {

    class ViewModel: ObservableObject {
        enum ViewMode {
            case takePhoto
            case confirmPhoto
        }
    }

    @State private var scanLabelTypeIndex: Int = 0
    // TODO: need to figure out how to manage the state here
    @State private var takePicture: Bool = false
    @State private var isTakingPicture: Bool = false
    @State private var capturedImage: UIImage? = nil
    @State private var viewMode: ViewModel.ViewMode = .takePhoto

    private var overlayViewVm: LabelScannerOverlayView.ViewModel {
        return LabelScannerOverlayView.ViewModel(
                viewMode: self.$viewMode,
                selectedLabelTypeIndex: self.$scanLabelTypeIndex,
                onCapturePhotoTapped: self.onCapturePhotoTapped,
                onConfirmPhotoAction: self.onConfirmPhotoAction
        )
    }
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
                        .aspectRatio(capturedImage!.size, contentMode: .fill)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            } else {
                CameraView(vm: self.cameraViewVm)
            }
            LabelScannerOverlayView(vm: self.overlayViewVm)
        }
        .edgesIgnoringSafeArea(.vertical)
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
                self.viewMode = .confirmPhoto
            } else {
                print("error converting")
            }
        } else {
            print(error)
            // TODO: proper logging and error handling
        }
    }

    private func onConfirmPhotoAction(didConfirm: Bool) {
        if !didConfirm {
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
