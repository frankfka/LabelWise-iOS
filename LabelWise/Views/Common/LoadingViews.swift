//
//  LoadingViews.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-03.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct FullScreenLoadingView: View {
    private static let IndicatorSize: CGFloat = 48
    private static let RingWidth: CGFloat = 6
    private static let TextPadding: CGFloat = CGFloat.App.Layout.normalPadding
    private static let Background: Color = Color.App.BackgroundPrimaryFillColor
    private static let TextFont: Font = Font.App.heading
    private static let TextColor: Color = Color.App.Text
    
    private let loadingText: String
    
    init(loadingText: String = "") {
        self.loadingText = loadingText
    }
    
    var body: some View {
        VStack(spacing: FullScreenLoadingView.TextPadding) {
            Spacer()
            LoadingIndicator(ringWidth: FullScreenLoadingView.RingWidth)
                .frame(width: FullScreenLoadingView.IndicatorSize, height: FullScreenLoadingView.IndicatorSize)
            if !self.loadingText.isEmpty {
                Text(self.loadingText)
                    .withStyle(font: FullScreenLoadingView.TextFont, color: FullScreenLoadingView.TextColor)
            }
            Spacer()
        }
        .fillWidthAndHeight()
        .background(FullScreenLoadingView.Background)
    }
}

struct LoadingViews_Previews: PreviewProvider {
    static var previews: some View {
        ColorSchemePreview {
            FullScreenLoadingView(loadingText: "Analyzing")
        }
    }
}
