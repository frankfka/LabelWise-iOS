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
    private static let DefaultViewSize: CGFloat = 300
    private static let CarbBackgroundColor: Color = Color.App.CarbIndicator.opacity(0.2)
    private static let ProteinBackgroundColor: Color = Color.App.ProteinIndicator.opacity(0.2)
    private static let FatBackgroundColor: Color = Color.App.FatIndicator.opacity(0.2)
    private static let CarbGradientColors: [Color] = [Color.App.CarbIndicator, Color.App.CarbIndicatorLight]
    private static let ProteinGradientColors: [Color] = [Color.App.ProteinIndicator, Color.App.ProteinIndicatorLight]
    private static let FatGradientColors: [Color] = [Color.App.FatIndicator, Color.App.FatIndicatorLight]
    private static let RelativeRingWidth: CGFloat = 0.1
    
    private let viewModel: ViewModel
    private let preferredViewSize: CGFloat? // Given as the size per dimension. This should be a square view
    private var viewSize: CGSize {
        let size = self.preferredViewSize ?? MacronutrientRings.DefaultViewSize
        return CGSize(width: size, height: size)
    }

    init(vm: ViewModel, preferredViewSize: CGFloat? = nil) {
        self.viewModel = vm
        self.preferredViewSize = preferredViewSize
    }
    
    var body: some View {
        ZStack {
            // Carbs - Biggest
            self.getPercentageRing(percent: self.viewModel.carbsPercentage, parentSize: self.viewSize,
                            backgroundColor: MacronutrientRings.CarbBackgroundColor,
                            foregroundColors: MacronutrientRings.CarbGradientColors)
                .frame(width: self.getMinDimension(size: self.viewSize), height: self.getMinDimension(size: self.viewSize))
            // Protein - Middle
            self.getPercentageRing(percent: self.viewModel.proteinPercentage, parentSize: self.viewSize,
                            backgroundColor: MacronutrientRings.ProteinBackgroundColor,
                            foregroundColors: MacronutrientRings.ProteinGradientColors)
                .frame(width: self.getMinDimension(size: self.viewSize) * (1 - MacronutrientRings.RelativeRingWidth * 2),
                        height: self.getMinDimension(size: self.viewSize) * (1 - MacronutrientRings.RelativeRingWidth * 2))
            // Fat - Smallest
            self.getPercentageRing(percent: self.viewModel.fatPercentage, parentSize: self.viewSize,
                            backgroundColor: MacronutrientRings.FatBackgroundColor,
                            foregroundColors: MacronutrientRings.FatGradientColors)
                .frame(width: self.getMinDimension(size: self.viewSize) * (1 - MacronutrientRings.RelativeRingWidth * 4),
                        height: self.getMinDimension(size: self.viewSize) * (1 - MacronutrientRings.RelativeRingWidth * 4))
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

        init(nutrition: Nutrition) {
            self.carbsPercentage = nutrition.carbohydratesDVPercent ?? 0
            self.proteinPercentage = nutrition.proteinDVPercent ?? 0
            self.fatPercentage = nutrition.fatDVPercent ?? 0
        }
    }
}

struct MacronutrientRings_Previews: PreviewProvider {

    private static let vm = MacronutrientRings.ViewModel(nutrition: PreviewNutritionModels.FullyParsedNutrition)

    static var previews: some View {
        MacronutrientRings(vm: vm)
    }
}
