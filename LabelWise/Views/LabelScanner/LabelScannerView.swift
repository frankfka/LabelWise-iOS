//
// Created by Frank Jia on 2020-04-18.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import SwiftUI
import SwiftUIExt
import Combine
import AVFoundation

struct LabelScannerView: View {

    @ObservedObject private var viewModel: ViewModel

    init(vm: ViewModel) {
        self.viewModel = vm
    }

    // Child view view models
    private var labelTypeVm: ViewModel.LabelTypePickerViewModel {
        ViewModel.LabelTypePickerViewModel(
            selectedIndex: self.$viewModel.selectedLabelTypeIndex,
            items: self.viewModel.displayedLabelTypes
        )
    }
    private var overlayViewVm: LabelScannerOverlayView.ViewModel {
        return LabelScannerOverlayView.ViewModel(
            state: self.$viewModel.state,
            labelTypePickerVm: labelTypeVm,
            onHelpIconTapped: self.viewModel.onHelpIconTapped,
            onCapturePhotoTapped: self.viewModel.onCapturePhotoTapped,
            onConfirmPhotoAction: self.viewModel.onConfirmPhotoAction
        )
    }
    private var cameraViewVm: CameraView.ViewModel {
        return CameraView.ViewModel(
            takePicture: self.$viewModel.takePicture,
            onCameraInitialized: self.viewModel.onCameraInitialized,
            onCameraError: self.viewModel.onCameraError,
            onPhotoCapture: self.viewModel.onPhotoCapture
        )
    }
    // Child views
    var viewForCurrentState: some View {
        if case let .confirmingPhoto(capturedImage) = self.viewModel.state {
            return Image(uiImage: capturedImage.uiImage)
                    .resizable()
                    .aspectRatio(capturedImage.uiImage.size, contentMode: .fill)
                    .fillWidthAndHeight()
                    .eraseToAnyView()
        } else if case .error = self.viewModel.state {
            return FullScreenErrorView(onTryAgainTapped: self.viewModel.onErrorTryAgainTapped)
                    .eraseToAnyView()
        } else {
            // Default to taking photo
            return CameraView(vm: self.cameraViewVm)
                    .eraseToAnyView()
        }
    }

    // MARK: Main View
    var body: some View {
        ZStack(alignment: .bottom) {
            viewForCurrentState
            LabelScannerOverlayView(vm: self.overlayViewVm)
        }
        // Note: Extra padding is applied in overlay header & footer views
        .edgesIgnoringSafeArea(.all)
        .fillWidthAndHeight()
        .onAppear(perform: self.viewModel.onViewAppear)
        .onDisappear(perform: self.viewModel.onViewDisappear)
    }
}

struct LabelScannerView_Previews: PreviewProvider {
    static let vm: LabelScannerView.ViewModel = LabelScannerView.ViewModel()

    static var previews: some View {
        ColorSchemePreview {
            LabelScannerView(vm: vm)
        }
    }
}
