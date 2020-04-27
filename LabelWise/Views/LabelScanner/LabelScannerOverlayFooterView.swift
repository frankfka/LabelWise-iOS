//
//  LabelScannerOverlayFooterView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-19.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct LabelScannerOverlayFooterView: View {

    class ViewModel: ObservableObject {
        let onCapturePhotoTapped: VoidCallback?
        let onConfirmPhotoAction: BoolCallback?
        var labelTypePickerVm: PickerViewModel
        @Binding var viewMode: LabelScannerView.ViewModel.ViewState

        init(viewMode: Binding<LabelScannerView.ViewModel.ViewState>, labelTypePickerVm: PickerViewModel,
             onCapturePhotoTapped: VoidCallback? = nil, onConfirmPhotoAction: BoolCallback? = nil) {
            self._viewMode = viewMode
            self.labelTypePickerVm = labelTypePickerVm
            self.onCapturePhotoTapped = onCapturePhotoTapped
            self.onConfirmPhotoAction = onConfirmPhotoAction
        }
    }
    private let viewModel: ViewModel
    private var typePickerViewModel: AnalyzeTypePicker.ViewModel {
        return AnalyzeTypePicker.ViewModel(labelTypePickerVm: self.viewModel.labelTypePickerVm)
    }

    init(vm: ViewModel) {
        self.viewModel = vm
    }

    var body: some View {
        VStack {
            AnalyzeTypePicker(vm: typePickerViewModel)
                .padding(.horizontal, CGFloat.App.Layout.largePadding)
                .padding(.bottom, CGFloat.App.Layout.normalPadding)
            if self.viewModel.viewMode == .takePhoto {
                CaptureIcon(onTap: self.viewModel.onCapturePhotoTapped)
            } else {
                PhotoActionIcons(onConfirmPhotoAction: self.viewModel.onConfirmPhotoAction)
            }
        }
        .padding(.bottom, CGFloat.App.Layout.largePadding)
        .padding(CGFloat.App.Layout.largePadding)
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(LabelScannerOverlayView.OverlayColor)
    }
    
}

struct PhotoActionIcons: View {
    private static let ButtonSize: CGFloat = CGFloat.App.Icon.largeButton
    private static let ButtonSpacing: CGFloat = CGFloat.App.Layout.extraLargePadding
    private let onConfirmPhotoAction: BoolCallback?

    init(onConfirmPhotoAction: BoolCallback?) {
        self.onConfirmPhotoAction = onConfirmPhotoAction
    }

    var body: some View {
        HStack(spacing: PhotoActionIcons.ButtonSpacing) {
            getIcon(isConfirm: false)
            getIcon(isConfirm: true)
        }
    }

    private func getIcon(isConfirm: Bool) -> some View {
        let image = isConfirm ? Image.App.labelScannerConfirmImage : Image.App.labelScannerCancelImage
        return image
            .resizable()
            .frame(width: PhotoActionIcons.ButtonSize, height: PhotoActionIcons.ButtonSize)
            .contentShape(Circle())
            .foregroundColor(Color.white)
            .onTapGesture {
                self.onConfirmPhotoAction?(isConfirm)
            }
    }

}


// Circular icon to take picture
struct CaptureIcon: View {
    private static let OuterRingSize: CGFloat = CGFloat.App.Icon.largeButton
    private static let DarkOuterRingSize: CGFloat = OuterRingSize * 0.9
    private static let InnerRingSize: CGFloat = DarkOuterRingSize * 0.9
    // Button Tap Animations
    private static let ButtonTapPressedAnimation: Animation = Animation.easeInOut(duration: 0.05)
    private static let ButtonTapReleasedAnimation: Animation = ButtonTapPressedAnimation.delay(0.05)
    private static let ButtonTapInnerRingScale: CGFloat = 0.95
    @State private var isAnimatingButtonTap: Bool = false

    private let onTap: VoidCallback?

    init(onTap: VoidCallback? = nil) {
        self.onTap = onTap
    }
    
    var body: some View {
        ZStack() {
            Circle()
                .foregroundColor(.white)
                .frame(width: CaptureIcon.OuterRingSize, height: CaptureIcon.OuterRingSize)
            Circle()
                .foregroundColor(.gray)
                .frame(width: CaptureIcon.DarkOuterRingSize, height: CaptureIcon.DarkOuterRingSize)
            Circle()
                .foregroundColor(.white)
                .frame(width: CaptureIcon.InnerRingSize, height: CaptureIcon.InnerRingSize)
                .scaleEffect(self.isAnimatingButtonTap ? CaptureIcon.ButtonTapInnerRingScale : 1)
        }
        .contentShape(Circle())
        .onTapGesture {
            self.animateButtonTap()
            self.onTap?()
        }
    }

    private func animateButtonTap() {
        withAnimation(CaptureIcon.ButtonTapPressedAnimation) {
            self.isAnimatingButtonTap = true
        }
        withAnimation(CaptureIcon.ButtonTapReleasedAnimation) {
            self.isAnimatingButtonTap = false
        }
    }

}

// Type picker to choose between nutrition/ingredients
struct AnalyzeTypePicker: View {
    
    class ViewModel: ObservableObject {
        @Published var labelTypePickerVm: PickerViewModel
        
        init(labelTypePickerVm: PickerViewModel) {
            self.labelTypePickerVm = labelTypePickerVm
        }
    }
    
    @ObservedObject private var viewModel: ViewModel
    
    init(vm: ViewModel) {
        self.viewModel = vm
    }
    
    var body: some View {
        // TODO: Lift these out
        Picker("Mode", selection: self.viewModel.labelTypePickerVm.selectedIndex) {
            Text("Nutrition")
                .tag(0)
            Text("Ingredients")
                .tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
            // TODO: dark mode, need to use systembackground
        // Makes sure we can read the text by adding a non-transparent background
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}


struct LabelScannerOverlayFooterView_Previews: PreviewProvider {
    static let labelTypePickerVm = LabelScannerView.ViewModel.LabelTypePickerViewModel(selectedIndex: .constant(0), items: AnalyzeType.allCases.map { $0.getPickerName() })
    static let vm = LabelScannerOverlayFooterView.ViewModel(viewMode: .constant(.takePhoto), labelTypePickerVm: labelTypePickerVm)
    static var previews: some View {
        LabelScannerOverlayFooterView(vm: vm)
    }
}
