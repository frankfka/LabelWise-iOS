//
//  AnalysisScrollView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-03.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// TODO: look into drag gesture to go back
struct AnalysisScrollView<HeaderContent: View, HeaderBackground: View, BodyContent: View>: View {
    // Not static as static constants are not supported in generic types
    private let navBarPadding: CGFloat = CGFloat.App.Layout.Padding
    private let navBarBottomPadding: CGFloat = CGFloat.App.Layout.SmallPadding
    private let headerHorizontalPadding: CGFloat = CGFloat.App.Layout.Padding
    private let headerTopPadding: CGFloat = CGFloat.App.Layout.LargePadding
    private let headerBottomPadding: CGFloat = CGFloat.App.Layout.LargestPadding
    private let backButtonContentColor: Color = Color.App.White
    
    private let bodyBackgroundRectangleRadius: CGFloat = CGFloat.App.Layout.CornerRadius
    private let bodyBackgroundColor: Color = Color.App.BackgroundPrimaryFillColor
    private let bodyContentPadding: CGFloat = CGFloat.App.Layout.Padding
    private let bodyContentBottomPadding: CGFloat = CGFloat.App.Layout.Padding
    
    private let onAppearExpandAnimationDuration: Double = 1
    private let onAppearOpacityAnimationDelay: Double = 0.2
    private let onAppearOpacityAnimationDuration: Double = 1.2

    private let onBackPressedCallback: VoidCallback?
    
    // Views
    private let headerContent: HeaderContent
    private let headerBackground: HeaderBackground
    private let bodyContentGenerator: GeometryAwareContentGenerator<BodyContent>
    
    // Composed views
    private var bodyBackground: some View {
        HalfRoundedRectangle(cornerRadius: bodyBackgroundRectangleRadius)
            .foregroundColor(bodyBackgroundColor)
    }
    private var scrollViewBackground: some View {
        VerticalTiledBackground(
            views: [
                self.headerBackground.eraseToAnyView(),
                self.bodyBackgroundColor.eraseToAnyView()
            ]
        )
    }
    
    // Animations
    @State private var isExpanded: Bool = false
    @State private var showContent: Bool = false // Show content after expanding

    init(header: HeaderContent, headerBackground: HeaderBackground, onBackPressedCallback: VoidCallback? = nil,
         @ViewBuilder body: @escaping GeometryAwareContentGenerator<BodyContent>) {
        self.headerContent = header
        self.headerBackground = headerBackground
        self.bodyContentGenerator = body
        self.onBackPressedCallback = onBackPressedCallback
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Navigation bar that overflows onto safe area
                HStack {
                    BackButton(
                        contentColor: self.backButtonContentColor,
                        text: "Scan Another",
                        onTapCallback: self.onBackPressedCallback
                    )
                    Spacer()
                }
                .fillWidth()
                .padding(.top, self.navBarPadding)
                .padding(.bottom, self.navBarBottomPadding)
                .padding(.horizontal, self.navBarPadding)
                .padding(.top, geometry.safeAreaInsets.top)
                .background(self.headerBackground)
                // Main content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        self.headerContent
                            .opacity(self.showContent ? 1 : 0) // Only show content after initial expansion
                            .fillWidth()
                            .padding(.bottom, self.bodyBackgroundRectangleRadius) // Bottom padding for rounded rect
                            .padding(.bottom, self.headerBottomPadding) // Larger bottom padding
                            .padding(.horizontal, self.headerHorizontalPadding)
                            .padding(.top, self.headerTopPadding)
                            .background(self.headerBackground)
                            .modifier(ExpandingSectionModifier(isExpanded: self.$isExpanded)) // Helper for expansion
                        self.bodyContentGenerator(geometry)
                            .padding(self.bodyContentPadding)
                            .padding(.top, self.bodyBackgroundRectangleRadius) // Top padding for rounded rect
                            .opacity(self.showContent ? 1 : 0) // Only show content after initial expansion
                            .fillWidthAndHeight()
                            .background(self.bodyBackground) // Apply rounded rectangle background
                            .offset(x: 0, y: -self.bodyBackgroundRectangleRadius)
                    }
                    .frame(minHeight: geometry.size.height)
                    .padding(.bottom, self.bodyContentBottomPadding) // Bottom padding to give some space to bottom of scrollview
                }
            }
            .fillWidthAndHeight()
            .edgesIgnoringSafeArea(.top)
            .background(self.scrollViewBackground)
            .onAppear(perform: self.onAppear)
        }
    }
    
    private func onAppear() {
        // Expand header
        withAnimation(Animation.easeInOut(duration: self.onAppearExpandAnimationDuration)) {
            self.isExpanded = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + self.onAppearOpacityAnimationDelay) {
            withAnimation(Animation.easeInOut(duration: self.onAppearOpacityAnimationDuration)) {
                self.showContent = true
            }
        }
    }
}


struct AnalysisScrollView_Previews: PreviewProvider {
    
    static private var PlaceholderHeader: some View {
        VStack {
            Text("Example Header")
                .withAppStyle(font: Font.App.LargeText, color: Color.App.White)
        }
    }
    
    static var previews: some View {
        AnalysisScrollView(
            header: PlaceholderHeader,
            headerBackground: Color.App.AppGreen) { viewGeometry in
            VStack {
                Text("Hello World")
            }
        }
    }
}
