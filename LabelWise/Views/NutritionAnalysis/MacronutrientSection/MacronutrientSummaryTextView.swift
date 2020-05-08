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
    
    private let viewModel: ViewModel
    
    init(vm: ViewModel) {
        self.viewModel = vm
    }
    
    var body: some View {
        VStack {
            getTextRow(name: "Carbs", amount: self.viewModel.carbsAmount,
                       dv: self.viewModel.carbsDV, color: Color.App.CarbIndicator)
            getTextRow(name: "Protein", amount: self.viewModel.proteinAmount,
                       dv: self.viewModel.proteinDV, color: Color.App.ProteinIndicator)
            getTextRow(name: "Fats", amount: self.viewModel.fatsAmount,
                       dv: self.viewModel.fatsDV, color: Color.App.FatIndicator)
        }
    }
    
    @ViewBuilder
    private func getTextRow(name: String, amount: String, dv: String, color: Color) -> some View {
        // TODO: Consider a left divider here with color
        // TODO: Alignment?
        HStack(alignment: .bottom, spacing: 0) {
            Text(amount)
                .withStyle(font: Font.App.NormalText, color: Color.App.Text)
                .bold()
                .lineLimit(1)
                .padding(.trailing, CGFloat.App.Layout.smallPadding)
            Text(name)
                .withStyle(font: Font.App.NormalText, color: color)
                .bold()
                .lineLimit(1)
            Spacer(minLength: CGFloat.App.Layout.normalPadding)
            Text(dv)
                .withStyle(font: Font.App.SmallText, color: Color.App.SecondaryText)
                .lineLimit(1)
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
