//
//  MacronutrientDistributionView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-07.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// MARK: View
struct MacronutrientDistributionView: View {
    private static let BarHeight: CGFloat = 10

    private let viewModel: ViewModel

    init(vm: ViewModel) {
        self.viewModel = vm
    }

    var body: some View {
        NutrientBreakdownBarChartView(values: self.viewModel.chartValues, barHeight: MacronutrientDistributionView.BarHeight)
    }
}

// MARK: View model
extension MacronutrientDistributionView {
    struct ViewModel {
        private let carbsRelativeWidth: Double
        private let proteinRelativeWidth: Double
        private let fatsRelativeWidth: Double
        var chartValues: [NutrientBreakdownBarChartView.Value] {
            [
                NutrientBreakdownBarChartView.Value(relativeWidth: carbsRelativeWidth, color: Color.App.CarbIndicator),
                NutrientBreakdownBarChartView.Value(relativeWidth: proteinRelativeWidth, color: Color.App.ProteinIndicator),
                NutrientBreakdownBarChartView.Value(relativeWidth: fatsRelativeWidth, color: Color.App.FatIndicator)
            ]
        }
        
        init(macros: Macronutrients) {
            // Ensure that total percentage is less than 100%, we may have cases where it is less (bad parsing)
            let carbsPercentage = macros.carbsPercentage ?? 0
            let proteinPercentage = macros.proteinPercentage ?? 0
            let fatsPercentage = macros.fatsPercentage ?? 0
            let totalPercentage = carbsPercentage + proteinPercentage + fatsPercentage
            if totalPercentage > 100 {
                // Scale to 100%
                self.carbsRelativeWidth = carbsPercentage / totalPercentage
                self.proteinRelativeWidth = proteinPercentage / totalPercentage
                self.fatsRelativeWidth = fatsPercentage / totalPercentage
            } else {
                self.carbsRelativeWidth = carbsPercentage.toDecimal()
                self.proteinRelativeWidth = proteinPercentage.toDecimal()
                self.fatsRelativeWidth = fatsPercentage.toDecimal()
            }
        }
    }
}

struct MacronutrientDistributionView_Previews: PreviewProvider {

    private static let vm = MacronutrientDistributionView.ViewModel(macros: PreviewNutritionModels.FullyParsedMacronutrients)

    static var previews: some View {
        ColorSchemePreview {
            MacronutrientDistributionView(vm: vm)
                .padding()
        }.previewLayout(.sizeThatFits)
    }
}
