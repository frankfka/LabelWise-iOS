//
//  CameraScanView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-18.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct CameraScanView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .foregroundColor(.green)
            CameraViewFinderOverlay()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}

struct CameraOverlayHeaderView: View {
    var body: some View {
        HStack {
            Spacer(minLength: 48)
            Text("Place label within the view")
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .foregroundColor(.white)
            Spacer(minLength: 48)
            Image(systemName: "questionmark.circle.fill")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.white)
                // Allow center element to be centered
                .padding(.leading, -24)
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 64)
        .background(CameraViewFinderOverlay.OverlayColor)
    }
}

struct CameraOverlayFooterView: View {
    
    @State private var selection = 0
    @State private var imageTypes = ["Nutrition","Ingredients"]
    
    var body: some View {
        VStack {
            Picker("Mode", selection: $selection) {
                ForEach(0 ..< imageTypes.count) { index in
                    Text(self.imageTypes[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 32)
            .padding(.bottom, 16)
            CameraCaptureIcon()
        }
        .padding()
        .contentShape(Rectangle())
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(CameraViewFinderOverlay.OverlayColor)
    }
}

struct CameraCaptureIcon: View {
    var body: some View {
        ZStack() {
            Circle()
                .foregroundColor(.white)
                .frame(width: 64, height: 64)
            Circle()
                .foregroundColor(.gray)
                .frame(width: 60, height: 60)
            Circle()
                .foregroundColor(.white)
                .frame(width: 54, height: 54)
        }
        .contentShape(Circle())
    }
}

struct CameraViewFinderOverlay: View {
    
    static let OverlayColor = Color.black.opacity(0.8)
    
    var body: some View {
            VStack(spacing: 0) {
                CameraOverlayHeaderView()
                GeometryReader { geometry in
                    Rectangle()
                        .fill(CameraViewFinderOverlay.OverlayColor)
                        .mask(
                            self.getViewFinderMask(parentSize: geometry.size)
                                .fill(style: FillStyle(eoFill: true, antialiased: true))
                    )
                }
                CameraOverlayFooterView()
            }
    }
    
    private func getViewFinderMask(parentSize: CGSize) -> Path {
        let parentRect = CGRect(x: 0, y: 0, width: parentSize.width, height: parentSize.height)
        let rect = CGRect(x: parentSize.width * 0.1, y: 0, width: parentSize.width * 0.8, height: parentSize.height)
        var shape = Rectangle().path(in: parentRect)
        shape.addPath(RoundedRectangle(cornerRadius: 24).path(in: rect))
        return shape
    }
}

struct CameraScanView_Previews: PreviewProvider {
    static var previews: some View {
        CameraScanView()
    }
}
