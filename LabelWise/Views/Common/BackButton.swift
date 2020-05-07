//
//  BackButton.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-06.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct BackButton: View {
    private static let BackIcon: Image = Image.App.LeftChevron
    private static let IconSize: CGFloat = CGFloat.App.Icon.ExtraSmallIcon
    private static let ElementSpacing: CGFloat = CGFloat.App.Layout.smallPadding
    private static let TextFont: Font = Font.App.NormalText
    private static let TappableAreaPadding: CGFloat = CGFloat.App.Layout.smallPadding
    
    private let contentColor: Color
    private let text: String
    private let onTapCallback: VoidCallback?
    
    init(contentColor: Color = Color.App.Text, text: String = "Back", onTapCallback: VoidCallback? = nil) {
        self.contentColor = contentColor
        self.text = text
        self.onTapCallback = onTapCallback
    }
    
    var body: some View {
        HStack(spacing: BackButton.ElementSpacing) {
            BackButton.BackIcon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: BackButton.IconSize, height: BackButton.IconSize)
                .foregroundColor(self.contentColor)
            Text(self.text)
                .withStyle(font: BackButton.TextFont, color: self.contentColor)
        }
        // Don't pad leading for easier layout
        .padding(.vertical, BackButton.TappableAreaPadding)
        .padding(.trailing, BackButton.TappableAreaPadding)
        .onTapGesture {
            self.onTapCallback?()
        }
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton()
            .previewLayout(.sizeThatFits)
    }
}
