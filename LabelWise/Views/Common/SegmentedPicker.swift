//
//  SegmentedPicker.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-30.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// https://stackoverflow.com/questions/56505043/how-to-make-view-the-size-of-another-view-in-swiftui/56661706#56661706
struct WidthPreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct TextGeometry: View {
    var body: some View {
        GeometryReader { geometry in
            return Rectangle().fill(Color.clear).preference(key: WidthPreferenceKey.self, value: geometry.size)
        }
    }
}

struct SegmentedPicker: View {
    private static let SegmentCornerRadius: CGFloat = CGFloat.App.Layout.SmallCornerRadius
    private static let ShadowRadius: CGFloat = CGFloat.App.Layout.ShadowRadius
    private static let ShadowColor: Color = Color.App.Shadow
    
    private let viewModel: PickerViewModel
    @State private var segmentSize: CGSize = .zero
    private var initialized: Bool {
        segmentSize != .zero
    }
    
    init(vm: PickerViewModel) {
        self.viewModel = vm
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                if self.initialized {
                    self.activeSegmentView
                }
                HStack {
                    ForEach(0..<self.viewModel.items.count, id: \.self) { index in
                        self.getSegmentView(for: index)
                    }
                }
            }
            .padding(CGFloat.App.Layout.extraSmallPadding)
            .background(Color(.systemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: SegmentedPicker.SegmentCornerRadius))
        }
    }
    
    // Displayed background for active segments
    var activeSegmentView: AnyView {
        RoundedRectangle(cornerRadius: SegmentedPicker.SegmentCornerRadius)
            .foregroundColor(Color.white)
            .shadow(color: SegmentedPicker.ShadowColor, radius: SegmentedPicker.ShadowRadius)
            .frame(width: self.segmentSize.width, height: self.segmentSize.height)
            .offset(x: computeActiveSegmentHorizontalOffset(), y: 0)
            .animation(.linear)
            .eraseToAnyView()
    }
    
    private func computeActiveSegmentHorizontalOffset() -> CGFloat {
        return CGFloat(self.viewModel.selectedIndex.wrappedValue) * (self.segmentSize.width + CGFloat.App.Layout.normalPadding / 2)
    }
    
    private func getSegmentView(for index: Int) -> some View {
        guard index < self.viewModel.items.count else {
            return EmptyView().eraseToAnyView()
        }
        let isSelected = self.viewModel.selectedIndex.wrappedValue == index
        // Redundant, but looks cleaner
        return {
            Text(self.viewModel.items[index])
                .withStyle(font: Font.App.smallText,
                           color: isSelected ? Color.App.textDark: Color.App.text)
                .lineLimit(1)
                .padding(.vertical, CGFloat.App.Layout.smallPadding)
                .padding(.horizontal, CGFloat.App.Layout.normalPadding)
                .fillWidth()
                .background(TextGeometry())
                .onPreferenceChange(WidthPreferenceKey.self, perform: { self.segmentSize = $0 })
                .onTapGesture {
                    self.viewModel.selectedIndex.wrappedValue = index
                }
                .eraseToAnyView()
        }()
    }
    
    private func onItemTap(index: Int) {
        guard index < self.viewModel.items.count else {
            return
        }
        self.viewModel.selectedIndex.wrappedValue = index
    }
    
}

struct SegmentedPicker_Previews: PreviewProvider {
    
    struct SegmentedPickerViewModel: PickerViewModel {
        var selectedIndex: Binding<Int>
        var items: [String] = ["M", "T", "W", "T", "F"]
        
        init(selectedIndex: Binding<Int>) {
            self.selectedIndex = selectedIndex
        }
    }
    
    // To allow for animations in preview
    struct SegmentedPickerPreviewView: View {
        
        @State var selectedIndex: Int = 0
        
        var body: some View {
            SegmentedPicker(vm: SegmentedPickerViewModel(selectedIndex: $selectedIndex))
                .onAppear(perform: self.onAppear)
        }
        
        private func onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.selectedIndex = 4
            }
        }
    }
    
    static var previews: some View {
        SegmentedPickerPreviewView()
    }
}
