//
//  LabelScannerOverlayHeaderView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-19.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// TODO: extract static consts
struct LabelScannerOverlayHeaderView: View {
    private static let MinSpacerLength: CGFloat = CGFloat.App.Layout.extraLargePadding
    private static let HelpIconSize: CGFloat = CGFloat.App.Icon.normal

    var body: some View {
        HStack {
            Spacer(minLength: LabelScannerOverlayHeaderView.MinSpacerLength)
            Text("Place label within the view")
                .withStyle(font: Font.App.smallText, color: Color.App.White)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            Spacer(minLength: LabelScannerOverlayHeaderView.MinSpacerLength)
            Image.App.QuestionMarkCircleFill
                .resizable()
                .frame(width: LabelScannerOverlayHeaderView.HelpIconSize,
                        height: LabelScannerOverlayHeaderView.HelpIconSize)
                .foregroundColor(.white)
                // Allow center element to be centered
                .padding(.leading, -LabelScannerOverlayHeaderView.MinSpacerLength)
        }
        .padding(CGFloat.App.Layout.largePadding)
        .padding(.top, CGFloat.App.Layout.largePadding)
        .fillWidth()
        .background(LabelScannerOverlayView.OverlayColor)
    }
}

struct LabelScannerOverlayHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        LabelScannerOverlayHeaderView()
            .previewLayout(.sizeThatFits)
    }
}
