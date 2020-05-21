//
//  LabelScannerOverlayHeaderView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-19.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct LabelScannerOverlayHeaderView: View {
    // View
    private static let ViewPadding: CGFloat = CGFloat.App.Layout.Padding
    private static let MinSpacerLength: CGFloat = CGFloat.App.Layout.LargestPadding
    // Help Icon
    private static let HelpIconSize: CGFloat = CGFloat.App.Icon.SmallIcon
    private static let HelpIconTappablePadding: CGFloat = CGFloat.App.Layout.SmallPadding
    // Help text
    private static let HelpTextFont: Font = Font.App.SmallText
    private static let HelpTextColor: Color = Color.App.White
    private static let HelpIconColor: Color = Color.App.White

    private let helpIconTappedCallback: VoidCallback?

    init(helpIconTappedCallback: VoidCallback? = nil) {
        self.helpIconTappedCallback = helpIconTappedCallback
    }

    var body: some View {
        HStack {
            Spacer(minLength: LabelScannerOverlayHeaderView.MinSpacerLength)
            Text("Place label within the view")
                .withAppStyle(font: LabelScannerOverlayHeaderView.HelpTextFont, color: LabelScannerOverlayHeaderView.HelpTextColor)
                .multiline()
                .multilineTextAlignment(.center)
                // Center the text
                .offset(x: LabelScannerOverlayHeaderView.HelpIconSize + LabelScannerOverlayHeaderView.HelpIconTappablePadding, y: 0)
            Spacer(minLength: LabelScannerOverlayHeaderView.MinSpacerLength)
            Image.App.QuestionMarkCircleFill
                .resizable()
                .frame(width: LabelScannerOverlayHeaderView.HelpIconSize,
                        height: LabelScannerOverlayHeaderView.HelpIconSize)
                .padding(LabelScannerOverlayHeaderView.HelpIconTappablePadding)
                .foregroundColor(LabelScannerOverlayHeaderView.HelpIconColor)
                .onTapGesture { self.helpIconTappedCallback?() }
        }
        .padding(LabelScannerOverlayHeaderView.ViewPadding)
        .fillWidth()
    }
}

struct LabelScannerOverlayHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        LabelScannerOverlayHeaderView()
            .background(Color.App.Overlay)
            .previewLayout(.sizeThatFits)
    }
}
