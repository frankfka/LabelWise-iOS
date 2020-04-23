//
//  LabelScannerOverlayHeaderView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-19.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct LabelScannerOverlayHeaderView: View {
    static let MinSpacerLength: CGFloat = 48
    static let HelpIconSize: CGFloat = 24

    var body: some View {
        HStack {
            Spacer(minLength: LabelScannerOverlayHeaderView.MinSpacerLength)
            Text("Place label within the view")
                    // TODO: Fonts and color
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .foregroundColor(.white)
            Spacer(minLength: LabelScannerOverlayHeaderView.MinSpacerLength)
            Image(systemName: "questionmark.circle.fill")
                .resizable()
                .frame(width: LabelScannerOverlayHeaderView.HelpIconSize,
                        height: LabelScannerOverlayHeaderView.HelpIconSize)
                .foregroundColor(.white)
                // Allow center element to be centered
                .padding(.leading, -LabelScannerOverlayHeaderView.MinSpacerLength)
        }
        .padding()
        .padding(.top, 32)
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(LabelScannerOverlayView.ViewModel.OverlayColor)
    }
}

struct LabelScannerOverlayHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        LabelScannerOverlayHeaderView()
            .previewLayout(.sizeThatFits)
    }
}
