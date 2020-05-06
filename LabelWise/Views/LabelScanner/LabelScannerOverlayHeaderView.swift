//
//  LabelScannerOverlayHeaderView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-19.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct LabelScannerOverlayHeaderView: View {
    private static let MinSpacerLength: CGFloat = CGFloat.App.Layout.extraLargePadding
    private static let HelpIconSize: CGFloat = CGFloat.App.Icon.NormalIcon
    private static let ViewPadding: CGFloat = CGFloat.App.Layout.largePadding
    private static let HelpTextFont: Font = Font.App.smallText
    private static let HelpTextColor: Color = Color.App.White
    private static let HelpIconColor: Color = Color.App.White

    var body: some View {
        HStack {
            Spacer(minLength: LabelScannerOverlayHeaderView.MinSpacerLength)
            Text("Place label within the view")
                .withStyle(font: LabelScannerOverlayHeaderView.HelpTextFont, color: LabelScannerOverlayHeaderView.HelpTextColor)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            Spacer(minLength: LabelScannerOverlayHeaderView.MinSpacerLength)
            Image.App.QuestionMarkCircleFill
                .resizable()
                .frame(width: LabelScannerOverlayHeaderView.HelpIconSize,
                        height: LabelScannerOverlayHeaderView.HelpIconSize)
                .foregroundColor(LabelScannerOverlayHeaderView.HelpIconColor)
                // Allow center element to be centered
                .padding(.leading, -LabelScannerOverlayHeaderView.MinSpacerLength)
        }
        .padding(LabelScannerOverlayHeaderView.ViewPadding)
        .fillWidth()
    }
}

struct LabelScannerOverlayHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        LabelScannerOverlayHeaderView()
            .previewLayout(.sizeThatFits)
    }
}
