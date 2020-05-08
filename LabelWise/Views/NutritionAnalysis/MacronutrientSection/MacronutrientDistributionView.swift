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
    private static let PlaceholderColor: Color = Color.App.PrimaryFillColor
    private static let BarHeight: CGFloat = 8
    private static let BorderRadius: CGFloat = 4

    private let viewModel: ViewModel

    init(vm: ViewModel) {
        self.viewModel = vm
    }

    var body: some View {
            ZStack(alignment: .leading) {
                GeometryReader { geometry in
                // Bottom placeholder
                self.getRectangle(relativeWidth: 1, parentSize: geometry.size, color: MacronutrientDistributionView.PlaceholderColor)
                // Macronutrient bars
                HStack(spacing: 0) {
                    self.getRectangle(relativeWidth: self.viewModel.carbsRelativeWidth,
                            parentSize: geometry.size, color: Color.App.CarbIndicator)
                    self.getRectangle(relativeWidth: self.viewModel.proteinRelativeWidth,
                            parentSize: geometry.size, color: Color.App.ProteinIndicator)
                    self.getRectangle(relativeWidth: self.viewModel.fatsRelativeWidth,
                            parentSize: geometry.size, color: Color.App.FatIndicator)
                }
            }
            .frame(height: MacronutrientDistributionView.BarHeight)
            .clipShape(RoundedRectangle(cornerRadius: MacronutrientDistributionView.BorderRadius))
        }
    }
    
    @ViewBuilder
    private func getRectangle(relativeWidth: Double, parentSize: CGSize, color: Color) -> some View {
        Rectangle()
            .frame(width: parentSize.width * relativeWidth.toCGFloat())
            .foregroundColor(color)
    }
}

// MARK: View model
extension MacronutrientDistributionView {
    struct ViewModel {
        let carbsRelativeWidth: Double
        let proteinRelativeWidth: Double
        let fatsRelativeWidth: Double
        
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
