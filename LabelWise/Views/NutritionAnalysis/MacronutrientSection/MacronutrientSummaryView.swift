//
// Created by Frank Jia on 2020-04-29.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI

extension Double {
    func toPercent() -> Double {
        return self * 100
    }
    func toDecimal() -> Double {
        return self / 100
    }
}

struct MacronutrientSummaryView: View {
    
    struct ViewModel {
        let dailyValues: DailyNutritionValues
        let macros: Macronutrients
        
        init(dto: AnalyzeNutritionResponseDTO.ParsedNutrition, dailyValues: DailyNutritionValues) {
            self.macros = Macronutrients(nutritionDto: dto, dailyValues: dailyValues)
            self.dailyValues = dailyValues
        }
    }
    
    private let viewModel: ViewModel
    
    init(vm: ViewModel) {
        self.viewModel = vm
    }
    
    // Child view models
    private var ringViewVm: MacronutrientRings.ViewModel {
        MacronutrientRings.ViewModel(macros: self.viewModel.macros)
    }
    private var summaryTextViewVm: MacronutrientSummaryTextView.ViewModel {
        MacronutrientSummaryTextView.ViewModel(macros: self.viewModel.macros)
    }
    private var distributionViewVm: MacronutrientDistributionView.ViewModel {
        MacronutrientDistributionView.ViewModel(macros: self.viewModel.macros)
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: CGFloat.App.Layout.normalPadding) {
                MacronutrientRings(vm: self.ringViewVm)
                        .frame(width: geometry.size.width / 3, height: geometry.size.width / 3)
                VStack {
                    MacronutrientSummaryTextView(vm: self.summaryTextViewVm)
                    MacronutrientDistributionView(vm: self.distributionViewVm)
                }
            }
        }
    }
}

struct MacronutrientSummaryView_Previews: PreviewProvider {
    private static let vm = MacronutrientSummaryView.ViewModel(
        dto: PreviewNutritionModels.FullyParsedNutritionDto,
        dailyValues: DailyNutritionValues()
    )
    
    static var previews: some View {
        ColorSchemePreview {
            MacronutrientSummaryView(vm: vm)
                .padding()
                .background(Color.App.BackgroundPrimaryFillColor)
        }
    }
}
