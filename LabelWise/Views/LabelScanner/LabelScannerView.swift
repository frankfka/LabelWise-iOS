//
// Created by Frank Jia on 2020-04-18.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import SwiftUI
import AVFoundation

// TODO: status bar color
struct LabelScannerView: View {

    class ViewModel: ObservableObject {
        struct LabelTypePickerViewModel: PickerViewModel {
            var selectedIndex: Binding<Int>
            let items: [String] = LabelTypes.allCases.map { $0.rawValue }

            init(selectedIndex: Binding<Int>) {
                self.selectedIndex = selectedIndex
            }
        }
        enum ViewMode {
            case takePhoto
            case confirmPhoto
        }
        enum LabelTypes: String, CaseIterable {
            case nutrition = "Nutrition"
            case ingredients = "Ingredients"
        }
    }
    @State private var scanLabelTypeIndex: Int = 0
    @State private var takePicture: Bool = false
    @State private var isTakingPicture: Bool = false
    @State private var capturedImage: UIImage? = nil
    @State private var viewMode: ViewModel.ViewMode = .takePhoto
    @State private var selectedLabelTypeIndex = 0
    private var labelTypeVm: ViewModel.LabelTypePickerViewModel {
        ViewModel.LabelTypePickerViewModel(selectedIndex: self.$selectedLabelTypeIndex)
    }

    private var overlayViewVm: LabelScannerOverlayView.ViewModel {
        return LabelScannerOverlayView.ViewModel(
                viewMode: self.$viewMode,
                labelTypePickerVm: labelTypeVm,
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
            // TODO: Clean this up!
            if self.capturedImage != nil {
                Image(uiImage: self.capturedImage!)
                    .resizable()
                    .aspectRatio(self.capturedImage!.size, contentMode: .fill)
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
        if !self.isTakingPicture {
            // Take a picture if one isn't in progress
            self.takePicture = true
            self.isTakingPicture = true
            // TODO: Some loading state
        }
    }

    private func onPhotoCapture(photo: LabelPhoto?, error: Error?) {
        self.takePicture = false
        self.isTakingPicture = false
        if let photo = photo, error == nil {
            if let uiImage = UIImage(data: photo.fileData) {
                self.capturedImage = uiImage
                self.viewMode = .confirmPhoto
            } else {
            }
        } else {
            print(error)
            // TODO: proper logging and error handling
        }
    }

    private func onConfirmPhotoAction(didConfirm: Bool) {
        if didConfirm {
            // TODO: Push to some other view
        } else {
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
