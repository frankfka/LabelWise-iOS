//
//  MacronutrientRings.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-29.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// MARK: View
struct MacronutrientRings: View {
    private static let CarbBackgroundColor: Color = Color.App.CarbIndicator.opacity(0.2)
    private static let ProteinBackgroundColor: Color = Color.App.ProteinIndicator.opacity(0.2)
    private static let FatBackgroundColor: Color = Color.App.FatIndicator.opacity(0.2)
    private static let CarbGradientColors: [Color] = [Color.App.CarbIndicator, Color.App.CarbIndicatorLight]
    private static let ProteinGradientColors: [Color] = [Color.App.ProteinIndicator, Color.App.ProteinIndicatorLight]
    private static let FatGradientColors: [Color] = [Color.App.FatIndicator, Color.App.FatIndicatorLight]
    private static let RelativeRingWidth: CGFloat = 0.1
    
    private let viewModel: ViewModel

    init(vm: ViewModel) {
        self.viewModel = vm
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Carbs - Biggest
                self.getPercentageRing(percent: self.viewModel.carbsPercentage, parentSize: geometry.size,
                                       backgroundColor: MacronutrientRings.CarbBackgroundColor,
                                       foregroundColors: MacronutrientRings.CarbGradientColors)
                        .frame(width: self.getMinDimension(size: geometry.size), height: self.getMinDimension(size: geometry.size))
                // Protein - Middle
                self.getPercentageRing(percent: self.viewModel.proteinPercentage, parentSize: geometry.size,
                                       backgroundColor: MacronutrientRings.ProteinBackgroundColor,
                                       foregroundColors: MacronutrientRings.ProteinGradientColors)
                    .frame(width: self.getMinDimension(size: geometry.size) * (1 - MacronutrientRings.RelativeRingWidth * 2),
                           height: self.getMinDimension(size: geometry.size) * (1 - MacronutrientRings.RelativeRingWidth * 2))
                // Fat - Smallest
                self.getPercentageRing(percent: self.viewModel.fatPercentage, parentSize: geometry.size,
                                backgroundColor: MacronutrientRings.FatBackgroundColor,
                                foregroundColors: MacronutrientRings.FatGradientColors)
                    .frame(width: self.getMinDimension(size: geometry.size) * (1 - MacronutrientRings.RelativeRingWidth * 4),
                            height: self.getMinDimension(size: geometry.size) * (1 - MacronutrientRings.RelativeRingWidth * 4))
            }
        }
    }
    
    private func getPercentageRing(percent: Double, parentSize: CGSize,
                                   backgroundColor: Color, foregroundColors: [Color]) -> some View {
        let maxDimension = getMinDimension(size: parentSize)
        return PercentageRing(percent: percent, ringWidth: maxDimension * MacronutrientRings.RelativeRingWidth,
                backgroundColor: backgroundColor, foregroundColors: foregroundColors)
    }
    
    private func getMinDimension(size: CGSize) -> CGFloat {
        min(size.width, size.height)
    }
    
}
// MARK: View model
extension MacronutrientRings {
    struct ViewModel {
        let carbsPercentage: Double
        let proteinPercentage: Double
        let fatPercentage: Double

        init(macros: Macronutrients) {
            self.carbsPercentage = macros.carbsDailyValuePercentage ?? 0
            self.proteinPercentage = macros.proteinDailyValuePercentage ?? 0
            self.fatPercentage = macros.fatsDailyValuePercentage ?? 0
        }
    }
}

struct MacronutrientRings_Previews: PreviewProvider {

    private static let vm = MacronutrientRings.ViewModel(macros: PreviewNutritionModels.FullyParsedMacronutrients)

    static var previews: some View {
        MacronutrientRings(vm: vm)
    }
}
