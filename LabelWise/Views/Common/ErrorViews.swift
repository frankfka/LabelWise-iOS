//
//  ErrorViews.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-03.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct ErrorDialogView: View {
    // View
    private static let SectionPadding: CGFloat = CGFloat.App.Layout.Padding
    // Icon
    private static let ErrorIcon: Image = Image.App.XMarkCircleFill
    private static let ErrorIconColor: Color = Color.App.Error
    private static let ErrorIconSize: CGFloat = CGFloat.App.Icon.LargeIcon
    // Text
    private static let TextPadding: CGFloat = CGFloat.App.Layout.SmallestPadding // Padding between text elements
    private static let ErrorHeaderFont: Font = Font.App.Subtitle
    private static let ErrorHeaderTextColor: Color = Color.App.Error
    private static let ErrorMessageFont: Font = Font.App.NormalText
    private static let ErrorMessageTextColor: Color = Color.App.SecondaryText
    
    private let onTryAgainTappedCallback: VoidCallback? // Button won't be shown if this isn't provided
    private let errorTitle: String
    private let errorMessage: String
    
    init(errorTitle: String? = nil, errorMessage: String? = nil, onTryAgainTapped: VoidCallback? = nil) {
        self.onTryAgainTappedCallback = onTryAgainTapped
        self.errorTitle = errorTitle ?? "Uh Oh."
        self.errorMessage = errorMessage ?? "Something went wrong."
    }
    
    var body: some View {
        VStack(spacing: ErrorDialogView.SectionPadding) {
            ErrorDialogView.ErrorIcon
                .resizable()
                .frame(width: ErrorDialogView.ErrorIconSize, height: ErrorDialogView.ErrorIconSize)
                .foregroundColor(ErrorDialogView.ErrorIconColor)
            VStack(spacing: ErrorDialogView.TextPadding) {
                Text(self.errorTitle)
                    .withAppStyle(font: ErrorDialogView.ErrorHeaderFont, color: ErrorDialogView.ErrorHeaderTextColor)
                    .singleLine()
                Text(self.errorMessage)
                    .withAppStyle(font: ErrorDialogView.ErrorMessageFont, color: ErrorDialogView.ErrorMessageTextColor)
                    .multiline()
                    .multilineTextAlignment(.center)
            }
            if self.onTryAgainTappedCallback != nil {
                RoundedRectangleTextButton(
                    "Try Again",
                    textColor: Color.white,
                    backgroundColor: Color.App.Error,
                    onTap: self.onTryAgainTapped
                )
            }
        }
    }
    
    private func onTryAgainTapped() {
        guard let onTap = self.onTryAgainTappedCallback else {
            AppLogging.warn("Try again button tapped, but no callback was given. This shouldn't happen")
            return
        }
        onTap()
    }
    
}

struct FullScreenErrorView: View {
    private static let Background: Color = Color.App.BackgroundPrimaryFillColor
    private static let ViewPadding: CGFloat = CGFloat.App.Layout.LargePadding
    private static let ErrorIcon: Image = Image.App.XMarkCircleFill
    private static let ErrorIconColor: Color = Color.App.Error
    private static let ErrorIconSize: CGFloat = CGFloat.App.Icon.LargeIcon
    private static let ErrorHeaderFont: Font = Font.App.LargeText
    private static let ErrorHeaderTextColor: Color = Color.App.Error
    private static let ErrorMessageFont: Font = Font.App.NormalText
    private static let ErrorMessageTextColor: Color = Color.App.SecondaryText
    private static let ErrorButtonTopPadding: CGFloat = CGFloat.App.Layout.Padding
    
    private let onTryAgainTappedCallback: VoidCallback?
    private let errorTitle: String?
    private let errorMessage: String?
    
    
    init(errorTitle: String? = nil, errorMessage: String? = nil, onTryAgainTapped: VoidCallback? = nil) {
        self.onTryAgainTappedCallback = onTryAgainTapped
        self.errorTitle = errorTitle
        self.errorMessage = errorMessage
    }
    
    var body: some View {
        VStack {
            Spacer()
            ErrorDialogView(
                errorTitle: self.errorTitle,
                errorMessage: self.errorMessage,
                onTryAgainTapped: self.onTryAgainTappedCallback
            )
            .padding(FullScreenErrorView.ViewPadding)
            Spacer()
        }
        .fillWidthAndHeight()
        .background(FullScreenErrorView.Background)
    }
}

struct ErrorViews_Previews: PreviewProvider {
    static var previews: some View {
        ColorSchemePreview {
            FullScreenErrorView(onTryAgainTapped: {})
            FullScreenErrorView()
        }
    }
}
