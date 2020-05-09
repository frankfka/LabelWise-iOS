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
        NutrientBreakdownBarChartView(values: self.viewModel.chartValues,
                barHeight: MacronutrientDistributionView.BarHeight)
    }
}

// MARK: View model
extension MacronutrientDistributionView {
    struct ViewModel {
        let chartValues: [NutrientBreakdownBarChartView.Value]
        
        init(macros: Macronutrients) {
            // Ensure that total percentage is less than 100%, we may have cases where it is less (bad parsing)
            let carbsPercentage = macros.carbsPercentage ?? 0
            let proteinPercentage = macros.proteinPercentage ?? 0
            let fatsPercentage = macros.fatsPercentage ?? 0
            self.chartValues = NutrientBreakdownBarChartView.getValues(from: [
                (carbsPercentage, Color.App.CarbIndicator),
                (proteinPercentage, Color.App.ProteinIndicator),
                (fatsPercentage, Color.App.FatIndicator)
            ], percentageForm: true)
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
