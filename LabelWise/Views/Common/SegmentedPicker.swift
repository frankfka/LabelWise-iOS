//
//  SegmentedPicker.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-30.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// https://stackoverflow.com/questions/56505043/how-to-make-view-the-size-of-another-view-in-swiftui/56661706#56661706
// https://swiftwithmajid.com/2020/01/15/the-magic-of-view-preferences-in-swiftui/
struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
struct BackgroundGeometryReader: View {
    var body: some View {
        GeometryReader { geometry in
            return Color
                    .clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }
}
struct SizeAwareViewModifier: ViewModifier {

    @Binding private var viewSize: CGSize

    init(viewSize: Binding<CGSize>) {
        self._viewSize = viewSize
    }

    func body(content: Content) -> some View {
        content
            .background(BackgroundGeometryReader())
            .onPreferenceChange(SizePreferenceKey.self, perform: { if self.viewSize != $0 { self.viewSize = $0 }})
    }
}

struct SegmentedPicker: View {
    private static let ActiveSegmentColor: Color = Color.App.BackgroundTertiaryFillColor
    private static let BackgroundColor: Color = Color.App.BackgroundSecondaryFillColor
    private static let ShadowColor: Color = Color.App.Shadow
    private static let TextColor: Color = Color.App.SecondaryText
    private static let SelectedTextColor: Color = Color.App.Text

    private static let TextFont: Font = Font.App.SmallText
    
    private static let SegmentCornerRadius: CGFloat = CGFloat.App.Layout.CornerRadius
    private static let ShadowRadius: CGFloat = CGFloat.App.Layout.ShadowRadius
    private static let SegmentXPadding: CGFloat = CGFloat.App.Layout.Padding
    private static let SegmentYPadding: CGFloat = CGFloat.App.Layout.SmallPadding
    private static let PickerPadding: CGFloat = CGFloat.App.Layout.SmallestPadding
    
    private static let AnimationDuration: Double = 0.1
    
    private let viewModel: PickerViewModel
    // Stores the size of a segment, used to create the active segment rect
    @State private var segmentSize: CGSize = .zero
    // Rounded rectangle to denote active segment
    private var activeSegmentView: AnyView {
        // Don't show the active segment until we have initialized the view
        // This is required for `.animation()` to display properly, otherwise the animation will fire on init
        let isInitialized: Bool = segmentSize != .zero
        if !isInitialized { return EmptyView().eraseToAnyView() }
        return
            RoundedRectangle(cornerRadius: SegmentedPicker.SegmentCornerRadius)
                .foregroundColor(SegmentedPicker.ActiveSegmentColor)
                .shadow(color: SegmentedPicker.ShadowColor, radius: SegmentedPicker.ShadowRadius)
                .frame(width: self.segmentSize.width, height: self.segmentSize.height)
                .offset(x: self.computeActiveSegmentHorizontalOffset(), y: 0)
                .animation(Animation.linear(duration: SegmentedPicker.AnimationDuration))
                .eraseToAnyView()
    }
    
    init(vm: PickerViewModel) {
        self.viewModel = vm
    }
    
    var body: some View {
        // Align the ZStack to the leading edge to make calculating offset on activeSegmentView easier
        ZStack(alignment: .leading) {
            // activeSegmentView indicates the current selection
            self.activeSegmentView
            HStack {
                ForEach(0..<self.viewModel.items.count, id: \.self) { index in
                    self.getSegmentView(for: index)
                }
            }
        }
        .padding(SegmentedPicker.PickerPadding)
        .background(SegmentedPicker.BackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: SegmentedPicker.SegmentCornerRadius))
    }

    // Helper method to compute the offset based on the selected index
    private func computeActiveSegmentHorizontalOffset() -> CGFloat {
        self.viewModel.selectedIndex.wrappedValue.toCGFloat() * (self.segmentSize.width + SegmentedPicker.SegmentXPadding / 2)
    }

    // Gets text view for the segment
    private func getSegmentView(for index: Int) -> some View {
        guard index < self.viewModel.items.count else {
            return EmptyView().eraseToAnyView()
        }
        let isSelected = self.viewModel.selectedIndex.wrappedValue == index
        return
            Text(self.viewModel.items[index])
                // Dark test for selected segment
                .withStyle(font: SegmentedPicker.TextFont,
                           color: isSelected ? SegmentedPicker.SelectedTextColor: SegmentedPicker.TextColor)
                .singleLine()
                .padding(.vertical, SegmentedPicker.SegmentYPadding)
                .padding(.horizontal, SegmentedPicker.SegmentXPadding)
                .fillWidth()
                // Watch for the size of the view
                .modifier(SizeAwareViewModifier(viewSize: self.$segmentSize))
                .onTapGesture { self.onItemTap(index: index) }
                .eraseToAnyView()
    }

    // On tap to change the selection
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.selectedIndex = 4
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.selectedIndex = 2
            }
        }
    }
    
    static var previews: some View {
        ColorSchemePreview {
            SegmentedPickerPreviewView()
            .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
