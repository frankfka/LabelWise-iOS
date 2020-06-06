//
//  OnboardingView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-04.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct OnboardingItemView: View {
    private static let IconSize: CGFloat = CGFloat.App.Icon.NormalIcon
    private static let IconColor: Color = Color.App.AppGreen
    private static let TextFont: Font = Font.App.LargeText
    private static let TextColor: Color = Color.App.Text
    
    private let icon: Image
    private let text: String
    
    init(text: String, icon: ContentGenerator<Image>) {
        self.text = text
        self.icon = icon()
    }
    
    var body: some View {
        VStack {
            self.icon
                .resizable()
                .frame(width: OnboardingItemView.IconSize, height: OnboardingItemView.IconSize)
                .foregroundColor(OnboardingItemView.IconColor)
            Text(self.text)
                .withAppStyle(font: OnboardingItemView.TextFont, color: OnboardingItemView.TextColor)
                .multiline()
                .multilineTextAlignment(.center)
        }
    }
    
}

struct OnboardingView: View {
    private static let VerticalViewPadding: CGFloat = CGFloat.App.Layout.LargestPadding
    private static let HorizontalViewPadding: CGFloat = CGFloat.App.Layout.LargePadding
    // Title Section
    private static let LogoSize: CGFloat = CGFloat.App.Icon.ExtraLargeIcon
    private static let AppTitleFont: Font = Font.App.Heading
    private static let AppTitleColor: Color = Color.App.Text
    private static let AppTitleTextSpacing: CGFloat = CGFloat.App.Layout.SmallPadding
    private static let AppSubtitleFont: Font = Font.App.LargeText
    private static let AppSubtitleColor: Color = Color.App.SecondaryText
    // Bottom button
    private static let GetStartedTextColor: Color = Color.App.White
    private static let GetStartedBackgroundColor: Color = Color.App.AppGreen
    
    private let onGetStartedTapped: VoidCallback?
    
    init(onGetStartedTapped: VoidCallback? = nil) {
        self.onGetStartedTapped = onGetStartedTapped
    }
    
    // MARK: Child views
    private var logoImage: some View {
        Image.App.Logo
            .resizable()
            .frame(
                width: OnboardingView.LogoSize,
                height: OnboardingView.LogoSize
            )
    }
    private var appTitleView: some View {
        VStack(spacing: OnboardingView.AppTitleTextSpacing) {
            Text("Labelwise")
                .withAppStyle(font: OnboardingView.AppTitleFont, color: OnboardingView.AppTitleColor)
                .singleLine()
            Text("Easily analyze nutrition and ingredient labels.")
                .withAppStyle(font: OnboardingView.AppSubtitleFont, color: OnboardingView.AppSubtitleColor)
                .multiline()
                .multilineTextAlignment(.center)
        }
    }
    // Instruction view items
    private var firstStepView: some View {
        OnboardingItemView(text: "Select the type of food label (nutrition/ingredient)") {
            Image.App.OneCircleFill
        }
    }
    private var secondStepView: some View {
        OnboardingItemView(text: "Take a photo of the label") {
            Image.App.TwoCircleFill
        }
    }
    private var thirdStepView: some View {
        OnboardingItemView(text: "Get easy-to-understand nutritional insights and analysis") {
            Image.App.ThreeCircleFill
        }
    }
    // Bottom Button
    private var getStartedButton: some View {
        RoundedRectangleTextButton(
            "Get Started",
            textColor: OnboardingView.GetStartedTextColor,
            backgroundColor: OnboardingView.GetStartedBackgroundColor,
            onTap: self.onGetStartedTapped
        )
        .fillWidth() // Weird issue where text is truncated if this isn't used
    }
    
    // MARK: Main view
    var body: some View {
        VStack {
            logoImage
            appTitleView
            Spacer()
            VStack(spacing: CGFloat.App.Layout.MediumPadding) {
                firstStepView
                secondStepView
                thirdStepView
            }
            Spacer()
            getStartedButton
        }
        .padding(.horizontal, OnboardingView.HorizontalViewPadding)
        .padding(.vertical, OnboardingView.VerticalViewPadding)
        .fillWidthAndHeight()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
