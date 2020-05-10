//
// Created by Frank Jia on 2020-04-29.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI

struct MacronutrientSectionView: View {
    private static let MacroRingsRelativeSize: CGFloat = 1/2
    private static let ViewSpacing: CGFloat = CGFloat.App.Layout.Padding

    private let viewModel: ViewModel
    // In a scroll view, we must have geometry reader in the outermost layer, so this is passed down
    private let parentSize: CGSize?
    private var macroRingViewSize: CGFloat? {
        if let parentSize = parentSize {
            let minDimension = min(parentSize.width, parentSize.height)
            return minDimension * MacronutrientSectionView.MacroRingsRelativeSize
        }
        return nil
    }
    
    init(vm: ViewModel, parentSize: CGSize? = nil) {
        self.viewModel = vm
        self.parentSize = parentSize
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
            MacronutrientRings(vm: self.ringViewVm, preferredViewSize: self.macroRingViewSize)
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
            MacronutrientSectionView(vm: vm)
                .padding()
                .background(Color.App.BackgroundPrimaryFillColor)
        }
    }
}
