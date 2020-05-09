//
//  MacronutrientSummaryTextView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-30.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// MARK: View
struct MacronutrientSectionTextView: View {
    private static let TextRowSpacing: CGFloat = CGFloat.App.Layout.SmallestPadding
    private static let AmountTextFont: Font = Font.App.NormalTextBold
    private static let AmountTextColor: Color = Color.App.Text
    private static let AmountTextSeparation: CGFloat = CGFloat.App.Layout.SmallestPadding
    private static let MacroNameFont: Font = Font.App.NormalTextBold
    private static let DVFont: Font = Font.App.SmallText
    private static let DVColor: Color = Color.App.SecondaryText
    
    private let viewModel: ViewModel
    
    init(vm: ViewModel) {
        self.viewModel = vm
    }
    
    var body: some View {
        VStack(spacing: MacronutrientSectionTextView.TextRowSpacing) {
            getTextRow(name: "Carbohydrates", amount: self.viewModel.carbsAmount,
                       dv: self.viewModel.carbsDV, color: Color.App.CarbIndicator)
            getTextRow(name: "Protein", amount: self.viewModel.proteinAmount,
                       dv: self.viewModel.proteinDV, color: Color.App.ProteinIndicator)
            getTextRow(name: "Fats", amount: self.viewModel.fatsAmount,
                       dv: self.viewModel.fatsDV, color: Color.App.FatIndicator)
        }
    }
    
    @ViewBuilder
    private func getTextRow(name: String, amount: String, dv: String, color: Color) -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            Text(amount)
                .withStyle(font: MacronutrientSectionTextView.AmountTextFont, color: MacronutrientSectionTextView.AmountTextColor)
                .singleLine()
                .padding(.trailing, MacronutrientSectionTextView.AmountTextSeparation)
            Text(name)
                .withStyle(font: MacronutrientSectionTextView.MacroNameFont, color: color)
                .singleLine()
            Spacer(minLength: CGFloat.App.Layout.Padding)
            Text(dv)
                .withStyle(font: MacronutrientSectionTextView.DVFont, color: MacronutrientSectionTextView.DVColor)
                .singleLine()
        }
    }
    
}
// MARK: View model
extension MacronutrientSectionTextView {
    struct ViewModel {
        let carbsAmount: String
        let carbsDV: String
        let proteinAmount: String
        let proteinDV: String
        let fatsAmount: String
        let fatsDV: String

        init(macros: Macronutrients) {
            self.carbsAmount = StringFormatters.formatNutrientAmount(macros.carbsGrams)
            self.proteinAmount = StringFormatters.formatNutrientAmount(macros.proteinGrams)
            self.fatsAmount = StringFormatters.formatNutrientAmount(macros.fatsGrams)
            self.carbsDV = StringFormatters.formatDVPercent(macros.carbsDailyValuePercentage)
            self.proteinDV = StringFormatters.formatDVPercent(macros.proteinDailyValuePercentage)
            self.fatsDV = StringFormatters.formatDVPercent(macros.fatsDailyValuePercentage)
        }
    }
}

struct MacronutrientSummaryTextView_Previews: PreviewProvider {
    // TODO: no info formatting
    private static let vm = MacronutrientSectionTextView.ViewModel(macros: PreviewNutritionModels.FullyParsedMacronutrients)
    
    static var previews: some View {
        ColorSchemePreview {
            MacronutrientSectionTextView(vm: vm)
                .padding()
                .background(Color.App.BackgroundPrimaryFillColor)
        }
        .previewLayout(.sizeThatFits)
    }
}
