//
//  ButtonViews.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-03.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct RoundedRectangleTextButton: View {
    private static let ButtonFont: Font = Font.App.normalText
    private static let HorizontalPadding: CGFloat = CGFloat.App.Layout.largePadding
    private static let VerticalPadding: CGFloat = CGFloat.App.Layout.normalPadding
    private static let BackgroundCornerRadius: CGFloat = CGFloat.App.Layout.CornerRadius
    
    private let text: String
    private let textColor: Color
    private let backgroundColor: Color
    private var background: some View {
        RoundedRectangle(cornerRadius: RoundedRectangleTextButton.BackgroundCornerRadius)
            .foregroundColor(self.backgroundColor)
    }
    private let onTap: VoidCallback
    
    init(_ text: String, textColor: Color, backgroundColor: Color, onTap: @escaping VoidCallback) {
        self.text = text
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: self.onTap) {
            Text(self.text)
                .withStyle(font: RoundedRectangleTextButton.ButtonFont, color: self.textColor)
                .padding(.vertical, RoundedRectangleTextButton.VerticalPadding)
                .padding(.horizontal, RoundedRectangleTextButton.HorizontalPadding)
        }
        .background(self.background)
    }
}

struct ButtonViews_Previews: PreviewProvider {
    static var previews: some View {
        // TODO: Previews
        Text("")
    }
}
