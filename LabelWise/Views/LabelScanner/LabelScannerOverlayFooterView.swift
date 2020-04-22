//
//  LabelScannerOverlayFooterView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-19.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct LabelScannerOverlayFooterView: View {

    @State private var typeSelection = 0
    private var typePickerViewModel: AnalyzeTypePicker.ViewModel {
        return AnalyzeTypePicker.ViewModel(typeSelection: self.$typeSelection)
    }
    private let onCapturePhotoTapped: VoidCallback?

    init(onCapturePhotoTapped: VoidCallback? = nil) {
        self.onCapturePhotoTapped = onCapturePhotoTapped
    }

    var body: some View {
        VStack {
            AnalyzeTypePicker(vm: typePickerViewModel)
            .padding(.horizontal, 32)
            .padding(.bottom, 16)
            CaptureIcon(onTap: self.onCapturePhotoTapped)
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(LabelScannerOverlayView.OverlayColor)
    }
    
}


// Circular icon to take picture
struct CaptureIcon: View {
    private static let OuterRingSize: CGFloat = 64
    private static let DarkOuterRingSize: CGFloat = 60
    private static let InnerRingSize: CGFloat = 54
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
            withAnimation(CaptureIcon.ButtonTapPressedAnimation) {
                self.isAnimatingButtonTap = true
            }
            withAnimation(CaptureIcon.ButtonTapReleasedAnimation) {
                self.isAnimatingButtonTap = false
            }
            self.onTap?()
        }
    }
}

// Type picker to choose between nutrition/ingredients
struct AnalyzeTypePicker: View {
    
    class ViewModel: ObservableObject {
        @Binding var typeSelection: Int
        
        init(typeSelection: Binding<Int>) {
            self._typeSelection = typeSelection
        }
    }
    
    @ObservedObject private var viewModel: ViewModel
    
    init(vm: ViewModel) {
        self.viewModel = vm
    }
    
    var body: some View {
        Picker("Mode", selection: self.viewModel.$typeSelection) {
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
    static var previews: some View {
        LabelScannerOverlayFooterView()
    }
}
