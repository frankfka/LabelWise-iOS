//
//  ErrorViews.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-03.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct FullScreenErrorView: View {
    private static let Background: Color = Color.App.BackgroundPrimaryFillColor
    private static let ErrorIcon: Image = Image.App.XMarkCircleFill
    private static let ErrorIconColor: Color = Color.App.Error
    private static let ErrorIconSize: CGFloat = CGFloat.App.Icon.LargeIcon
    private static let ErrorHeaderFont: Font = Font.App.heading
    private static let ErrorHeaderTextColor: Color = Color.App.Error
    private static let ErrorMessageFont: Font = Font.App.normalText
    private static let ErrorMessageTextColor: Color = Color.App.SecondaryText
    private static let ErrorButtonTopPadding: CGFloat = CGFloat.App.Layout.normalPadding
    
    private let onTryAgainTappedCallback: VoidCallback? // Button won't be shown if this isn't provided
    private let errorTitle: String
    private let errorMessage: String
    
    
    init(errorTitle: String? = nil, errorMessage: String? = nil, onTryAgainTapped: VoidCallback? = nil) {
        self.onTryAgainTappedCallback = onTryAgainTapped
        self.errorTitle = errorTitle ?? "Uh Oh."
        self.errorMessage = errorMessage ?? "Something went wrong."
    }
    
    var body: some View {
        VStack {
            Spacer()
            Section {
                FullScreenErrorView.ErrorIcon
                    .resizable()
                    .frame(width: FullScreenErrorView.ErrorIconSize, height: FullScreenErrorView.ErrorIconSize)
                    .foregroundColor(FullScreenErrorView.ErrorIconColor)
                Text(self.errorTitle)
                    .withStyle(font: FullScreenErrorView.ErrorHeaderFont, color: FullScreenErrorView.ErrorHeaderTextColor)
                Text(self.errorMessage)
                    .withStyle(font: FullScreenErrorView.ErrorMessageFont, color: FullScreenErrorView.ErrorMessageTextColor)
            }
            if self.onTryAgainTappedCallback != nil {
                RoundedRectangleTextButton(
                    "Try Again",
                    textColor: Color.white,
                    backgroundColor: Color.App.Error,
                    onTap: self.onTryAgainTapped
                )
                .padding(.top, FullScreenErrorView.ErrorButtonTopPadding)
            }
            Spacer()
        }
        .fillWidthAndHeight()
        .background(FullScreenErrorView.Background)
    }
    
    private func onTryAgainTapped() {
        guard let onTap = self.onTryAgainTappedCallback else {
            AppLogging.warn("Try again button tapped, but no callback was given. This shouldn't happen")
            return
        }
        onTap()
    }
    
}

struct ErrorViews_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenErrorView(onTryAgainTapped: {})
    }
}
