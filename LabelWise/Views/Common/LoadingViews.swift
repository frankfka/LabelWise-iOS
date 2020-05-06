//
//  LoadingViews.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-03.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct FullScreenLoadingView: View {
    // View
    private static let Background: Color = Color.App.BackgroundPrimaryFillColor
    private static let ViewPadding: CGFloat = CGFloat.App.Layout.largePadding
    // Loading Indicator
    private static let IndicatorSize: CGFloat = 48
    private static let RingWidth: CGFloat = 6
    // Text
    private static let TextPadding: CGFloat = CGFloat.App.Layout.normalPadding
    private static let TextFont: Font = Font.App.LargeText
    private static let TextColor: Color = Color.App.SecondaryText
    // Cancel Icon
    private static let CancelIcon: Image = Image.App.XMarkCircleFill
    private static let IconColor: Color = Color.App.AppYellow
    private static let IconSize: CGFloat = CGFloat.App.Icon.NormalIcon
    private static let IconTappablePadding: CGFloat = CGFloat.App.Layout.smallPadding
    
    private let loadingText: String
    private let onCancelCallback: VoidCallback? // Button to cancel won't be shown unless this is provided
    // Re-center loading icon if we have an additional cancel icon
    private var indicatorYOffset: CGFloat {
        if onCancelCallback == nil {
            return 0
        }
        return -FullScreenLoadingView.IconSize - FullScreenLoadingView.IconTappablePadding
    }
    
    init(loadingText: String = "", onCancelCallback: VoidCallback? = nil) {
        self.loadingText = loadingText
        self.onCancelCallback = onCancelCallback
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                self.onCancelCallback.map({
                    FullScreenLoadingView.CancelIcon
                        .resizable()
                        .frame(width: FullScreenLoadingView.IconSize, height: FullScreenLoadingView.IconSize)
                        .foregroundColor(FullScreenLoadingView.IconColor)
                        .padding(FullScreenLoadingView.IconTappablePadding)
                        .onTapGesture(perform: $0)
                })
            }
            Spacer()
            VStack(spacing: FullScreenLoadingView.TextPadding) {
                LoadingIndicator(ringWidth: FullScreenLoadingView.RingWidth)
                    .frame(width: FullScreenLoadingView.IndicatorSize, height: FullScreenLoadingView.IndicatorSize)
                if !self.loadingText.isEmpty {
                    Text(self.loadingText)
                        .withStyle(font: FullScreenLoadingView.TextFont, color: FullScreenLoadingView.TextColor)
                }
            }.offset(x: 0, y: indicatorYOffset)
            Spacer()
        }
        .padding(FullScreenLoadingView.ViewPadding)
        .fillWidthAndHeight()
        .background(FullScreenLoadingView.Background)
    }
}

struct LoadingViews_Previews: PreviewProvider {
    static var previews: some View {
        ColorSchemePreview {
            FullScreenLoadingView(loadingText: "Analyzing") {}
        }
    }
}
