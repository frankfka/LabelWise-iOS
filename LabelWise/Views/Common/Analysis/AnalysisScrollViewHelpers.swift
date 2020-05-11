//
//  AnalysisScrollViewHelpers.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-03.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// Modifier for expanding section - pretty simple, just hides the ugly if-else
struct ExpandingSectionModifier: ViewModifier {
    @Binding private var isExpanded: Bool
    
    init(isExpanded: Binding<Bool>) {
        self._isExpanded = isExpanded
    }
    
    func body(content: Content) -> some View {
        content
            .frame(maxHeight: self.isExpanded ? nil : 0)
    }
}

// Modifier for each section within the body
struct AnalysisSectionModifier: ViewModifier {
    private static let TitleFont: Font = Font.App.LargeTextBold
    private static let TitleColor: Color = Color.App.Text
    private static let TitleBottomPadding: CGFloat = CGFloat.App.Layout.Padding
    private static let SectionInsetPadding: CGFloat = CGFloat.App.Layout.Padding
    private static let Background: some View = {
        RoundedRectangle(cornerRadius: CGFloat.App.Layout.CornerRadius)
            .foregroundColor(Color.App.BackgroundSecondaryFillColor)
            .shadow(color: Color.App.Shadow, radius: 8, x: 0, y: 8)
    }()
    
    private let title: String
    private let alignment: HorizontalAlignment
    init(title: String, alignment: HorizontalAlignment = .center) {
        self.title = title
        self.alignment = alignment
    }
    
    func body(content: Content) -> some View {
        VStack(alignment: self.alignment, spacing: 0) {
            HStack {
                Text(self.title)
                    .withStyle(font: AnalysisSectionModifier.TitleFont, color: AnalysisSectionModifier.TitleColor)
                    .padding(.bottom, AnalysisSectionModifier.TitleBottomPadding)
                Spacer()
            }
            content
        }
        .padding(AnalysisSectionModifier.SectionInsetPadding)
        .background(AnalysisSectionModifier.Background)
    }
}

// Background with multiple colors to be consistent with different header/footer colors on overscroll
struct VerticalTiledBackground<Background: View>: View {
    
    private let views: [Background]
    
    init(views: [Background]) {
        self.views = views
    }
    
    var body: some View {
        VStack {
            ForEach(0..<views.count, id: \.self) { index in
                self.views[index]
            }
        }
    }
}
