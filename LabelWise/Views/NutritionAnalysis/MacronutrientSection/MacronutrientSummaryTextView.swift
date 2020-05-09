//
//  MacronutrientSummaryTextView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-30.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// MARK: View
struct MacronutrientSummaryTextView: View {
    private static let AmountTextFont: Font = Font.App.NormalTextBold
    private static let AmountTextColor: Color = Color.App.Text
    private static let AmountTextSeparation: CGFloat = CGFloat.App.Layout.smallPadding
    private static let MacroNameFont: Font = Font.App.NormalTextBold
    private static let DVFont: Font = Font.App.SmallText
    private static let DVColor: Color = Color.App.SecondaryText
    
    private let viewModel: ViewModel
    
    init(vm: ViewModel) {
        self.viewModel = vm
    }
    
    var body: some View {
        VStack {
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
                .withStyle(font: MacronutrientSummaryTextView.AmountTextFont, color: MacronutrientSummaryTextView.AmountTextColor)
                .singleLine()
                .padding(.trailing, MacronutrientSummaryTextView.AmountTextSeparation)
            Text(name)
                .withStyle(font: MacronutrientSummaryTextView.MacroNameFont, color: color)
                .singleLine()
            Spacer(minLength: CGFloat.App.Layout.normalPadding)
            Text(dv)
                .withStyle(font: MacronutrientSummaryTextView.DVFont, color: MacronutrientSummaryTextView.DVColor)
                .singleLine()
        }
    }
    
}
// MARK: View model
extension MacronutrientSummaryTextView {
    struct ViewModel {
        private static func formatAmount(_ amount: Double?) -> String {
            let amountStr: String
            if let amount = amount {
                amountStr = "\(amount.toString(numDecimalDigits: 1))"
            } else {
                amountStr = String.NoNumberPlaceholderText
            }
            return "\(amountStr)g"
        }
        private static func formatDVPercent(_ percent: Double?) -> String {
            let dvString: String
            if let percent = percent {
                dvString = percent.toString(numDecimalDigits: 0)
            } else {
                dvString = String.NoNumberPlaceholderText
            }
            return "(\(dvString)% DV)"
        }
    
        let carbsAmount: String
        let carbsDV: String
        let proteinAmount: String
        let proteinDV: String
        let fatsAmount: String
        let fatsDV: String

        init(macros: Macronutrients) {
            self.carbsAmount = ViewModel.formatAmount(macros.carbsGrams)
            self.proteinAmount = ViewModel.formatAmount(macros.proteinGrams)
            self.fatsAmount = ViewModel.formatAmount(macros.fatsGrams)
            self.carbsDV = ViewModel.formatDVPercent(macros.carbsDailyValuePercentage)
            self.proteinDV = ViewModel.formatDVPercent(macros.proteinDailyValuePercentage)
            self.fatsDV = ViewModel.formatDVPercent(macros.fatsDailyValuePercentage)
        }
    }
}

struct MacronutrientSummaryTextView_Previews: PreviewProvider {
    // TODO: no info formatting
    private static let vm = MacronutrientSummaryTextView.ViewModel(macros: PreviewNutritionModels.FullyParsedMacronutrients)
    
    static var previews: some View {
        ColorSchemePreview {
            MacronutrientSummaryTextView(vm: vm)
                .padding()
                .background(Color.App.BackgroundPrimaryFillColor)
        }
        .previewLayout(.sizeThatFits)
    }
}
