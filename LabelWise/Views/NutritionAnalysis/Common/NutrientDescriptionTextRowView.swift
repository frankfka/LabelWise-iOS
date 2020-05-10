//
//  NutrientDescriptionTextRowView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-09.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct NutrientDescriptionTextRowView: View {
    private static let AmountTextFont: Font = Font.App.NormalTextBold
    private static let AmountTextColor: Color = Color.App.Text
    private static let AmountTextSeparation: CGFloat = CGFloat.App.Layout.SmallestPadding
    private static let NutrientNameFont: Font = Font.App.NormalTextBold
    private static let DVFont: Font = Font.App.SmallText
    private static let DVColor: Color = Color.App.SecondaryText

    private let name: String
    private let amount: String
    private let dv: String
    private let indicatorColor: Color

    init(name: String, amount: String, dv: String, indicatorColor: Color) {
        self.name = name
        self.amount = amount
        self.dv = dv
        self.indicatorColor = indicatorColor
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Text(amount)
                .withStyle(font: NutrientDescriptionTextRowView.AmountTextFont, color: NutrientDescriptionTextRowView.AmountTextColor)
                .singleLine()
                .padding(.trailing, NutrientDescriptionTextRowView.AmountTextSeparation)
            Text(name)
                .withStyle(font: NutrientDescriptionTextRowView.NutrientNameFont, color: indicatorColor)
                .singleLine()
            Spacer(minLength: CGFloat.App.Layout.Padding)
            Text(dv)
                .withStyle(font: NutrientDescriptionTextRowView.DVFont, color: NutrientDescriptionTextRowView.DVColor)
                .singleLine()
        }
    }
}

struct NutrientDescriptionTextRowView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSchemePreview {
            NutrientDescriptionTextRowView(name: "Carbohydrates", amount: "20g", dv: "(20 %DV)", indicatorColor: Color.App.CarbIndicator)
                .padding()
                .background(Color.App.BackgroundSecondaryFillColor)
        }
        .previewLayout(.sizeThatFits)
    }
}
