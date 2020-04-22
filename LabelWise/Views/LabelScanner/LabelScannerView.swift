//
// Created by Frank Jia on 2020-04-18.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct LabelScannerView: View {

    @State private var scanLabelTypeIndex: Int = 0 // TODO: use this
    // TODO: need to figure out how to manage the state here
    @State private var takePicture: Bool = false
    @State private var isTakingPicture: Bool = false

    private var cameraViewVm: CameraView.ViewModel {
        return CameraView.ViewModel(
            takePicture: self.$takePicture,
            onPhotoCapture: self.onPhotoCapture
        )
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            CameraView(vm: self.cameraViewVm)
            LabelScannerOverlayView(onCapturePhotoTapped: onCapturePhotoTapped)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }

    private func onCapturePhotoTapped() {
        print("tapped")
        if !isTakingPicture {
            // Take a picture if one isn't in progress
            self.takePicture = true
            self.isTakingPicture = true
        }
    }
    
    private func onPhotoCapture() {
        print("on photo capture")
        self.takePicture = false
        self.isTakingPicture = false
        // TODO: do something with output
    }

}

struct LabelScannerView_Previews: PreviewProvider {
    static var previews: some View {
        LabelScannerView()
    }
}
