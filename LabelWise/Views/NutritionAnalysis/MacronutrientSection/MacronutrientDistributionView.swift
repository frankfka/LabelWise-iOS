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
        
        init(nutrition: Nutrition) {
            // Ensure that total percentage is less than 100%, we may have cases where it is less (bad parsing)
            let carbsPercentage = nutrition.carbohydratesPercent ?? 0
            let proteinPercentage = nutrition.proteinPercent ?? 0
            let fatsPercentage = nutrition.fatPercent ?? 0
            self.chartValues = NutrientBreakdownBarChartView.getValues(from: [
                (carbsPercentage, Color.App.CarbIndicator),
                (proteinPercentage, Color.App.ProteinIndicator),
                (fatsPercentage, Color.App.FatIndicator)
            ], percentageForm: true)
        }
    }
}

struct MacronutrientDistributionView_Previews: PreviewProvider {

    private static let vm = MacronutrientDistributionView.ViewModel(nutrition: PreviewNutritionModels.FullyParsedNutrition)

    static var previews: some View {
        ColorSchemePreview {
            MacronutrientDistributionView(vm: vm)
                .padding()
        }.previewLayout(.sizeThatFits)
    }
}
