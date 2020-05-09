//
// Created by Frank Jia on 2020-04-29.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI

struct MacronutrientSectionView: View {
    private static let MacroRingsMaxRelativeSize: CGFloat = 1/3
    private static let ViewSpacing: CGFloat = CGFloat.App.Layout.Padding

    private let viewModel: ViewModel
    // In a scroll view, we must have geometry reader in the outermost layer, so this is passed down
    private let approximateMinDimension: CGFloat
    
    init(vm: ViewModel, approximateMinDimension: CGFloat) {
        self.viewModel = vm
        self.approximateMinDimension = approximateMinDimension
    }
    
    // Child view models
    private var ringViewVm: MacronutrientRings.ViewModel {
        MacronutrientRings.ViewModel(macros: self.viewModel.macros)
    }
    private var summaryTextViewVm: MacronutrientSectionTextView.ViewModel {
        MacronutrientSectionTextView.ViewModel(macros: self.viewModel.macros)
    }
    private var distributionViewVm: MacronutrientDistributionView.ViewModel {
        MacronutrientDistributionView.ViewModel(macros: self.viewModel.macros)
    }
    
    var body: some View {
        VStack(spacing: MacronutrientSectionView.ViewSpacing) {
            MacronutrientRings(vm: self.ringViewVm)
                .frame(maxWidth: self.approximateMinDimension * MacronutrientSectionView.MacroRingsMaxRelativeSize,
                        maxHeight: self.approximateMinDimension * MacronutrientSectionView.MacroRingsMaxRelativeSize)
                .padding(.horizontal) // Weird bug where background rings don't show if we don't have this padding
            MacronutrientSectionTextView(vm: self.summaryTextViewVm)
            MacronutrientDistributionView(vm: self.distributionViewVm)
        }
    }
}
// MARK: View Model
extension MacronutrientSectionView {
    struct ViewModel {
        let dailyValues: DailyNutritionValues
        let macros: Macronutrients

        init(dto: AnalyzeNutritionResponseDTO.ParsedNutrition, dailyValues: DailyNutritionValues) {
            self.macros = Macronutrients(nutritionDto: dto, dailyValues: dailyValues)
            self.dailyValues = dailyValues
        }
    }
}

struct MacronutrientSummaryView_Previews: PreviewProvider {
    private static let vm = MacronutrientSectionView.ViewModel(
        dto: PreviewNutritionModels.FullyParsedNutritionDto,
        dailyValues: DailyNutritionValues()
    )
    
    static var previews: some View {
        ColorSchemePreview {
            MacronutrientSectionView(vm: vm, approximateMinDimension: 400)
                .padding()
                .background(Color.App.BackgroundPrimaryFillColor)
        }
    }
}