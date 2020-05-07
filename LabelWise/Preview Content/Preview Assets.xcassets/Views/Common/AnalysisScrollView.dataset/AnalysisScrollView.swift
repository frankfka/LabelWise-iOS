//
//  AnalysisScrollView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-03.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct AnalysisScrollView<HeaderContent: View, HeaderBackground: View, BodyContent: View>: View {
    // Not static as static constants are not supported in generic types
    private let headerPadding: CGFloat = CGFloat.App.Layout.extraLargePadding
    private let bodyBackgroundRectangleRadius: CGFloat = CGFloat.App.Layout.CornerRadius
    private let bodyBackgroundColor: Color = Color.App.BackgroundPrimaryFillColor
    private let onAppearAnimationDuration: Double = 0.8
    
    // Views
    private let headerContent: HeaderContent
    private let headerBackground: HeaderBackground
    private let bodyContent: BodyContent
    
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
    
    // Expand
    @State private var isExpanded: Bool = false

    init(header: HeaderContent, headerBackground: HeaderBackground, @ViewBuilder body: ContentGenerator<BodyContent>) {
        self.headerContent = header
        self.headerBackground = headerBackground
        self.bodyContent = body()
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    self.headerContent
                        .fillWidth()
                        // For layout
                        .padding(.top, geometry.safeAreaInsets.top)
                        .padding(.bottom, self.bodyBackgroundRectangleRadius)
                        // For readability
                        .padding(self.headerPadding)
                        .background(self.headerBackground)
                        .modifier(ExpandingSectionModifier(isExpanded: self.$isExpanded))
                    self.bodyContent
                        .fillWidthAndHeight()
                        .background(self.bodyBackground)
                        .offset(x: 0, y: -self.bodyBackgroundRectangleRadius)
                        .conditionalModifier(true) {
                            $0
                    }
                }
                .frame(minHeight: geometry.size.height)
            }
            .fillWidthAndHeight()
            .edgesIgnoringSafeArea(.top)
            .background(self.scrollViewBackground)
            .onAppear(perform: self.onAppear)
        }
    }
    
    private func onAppear() {
        // Expand header
        withAnimation(Animation.easeInOut(duration: self.onAppearAnimationDuration)) {
            self.isExpanded = true
        }
    }
    
}


struct AnalysisScrollView_Previews: PreviewProvider {
    
    static private var PlaceholderHeader: some View {
        VStack {
            Text("Example Header")
                .withStyle(font: Font.App.LargeText, color: Color.App.White)
        }
    }
    
    static var previews: some View {
        AnalysisScrollView(
            header: PlaceholderHeader,
            headerBackground: Color.App.AppGreen) {
            VStack {
                Text("Hello World")
            }
        }
    }
}
