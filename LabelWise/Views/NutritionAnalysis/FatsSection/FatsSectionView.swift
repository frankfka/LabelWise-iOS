//
//  FatsSectionView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-09.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// MARK: View
struct FatsSectionView: View {
    private static let VerticalItemSpacing: CGFloat = CGFloat.App.Layout.SmallestPadding
    private static let ChartBottomPadding: CGFloat = CGFloat.App.Layout.MediumPadding
    
    private let viewModel: ViewModel
    
    init(vm: ViewModel) {
        self.viewModel = vm
    }
    
    var body: some View {
        VStack(spacing: FatsSectionView.VerticalItemSpacing) {
            NutrientBreakdownBarChartView(values: self.viewModel.barChartValues)
                .padding(.bottom, FatsSectionView.ChartBottomPadding)
            NutrientDescriptionTextRowView(name: "Total", amount: self.viewModel.fatAmount, dv: self.viewModel.fatDV, indicatorColor: Color.App.Text)
            NutrientDescriptionTextRowView(name: "Saturated Fat", amount: self.viewModel.satFatAmount, dv: self.viewModel.satFatDV, indicatorColor: Color.App.SatFatIndicator)
            NutrientDescriptionTextRowView(name: "Cholesterol", amount: self.viewModel.cholesterolAmount, dv: self.viewModel.cholesterolDV, indicatorColor: Color.App.CholesterolIndicator)
        }
    }
}
// MARK: View model
extension FatsSectionView {
    struct ViewModel {
        // Values for breakdown chart
        let barChartValues: [NutrientBreakdownBarChartView.Value]
        // Strings for text breakdown
        let fatAmount: String
        let fatDV: String
        let satFatAmount: String
        let satFatDV: String
        let cholesterolAmount: String
        let cholesterolDV: String
        
        init(nutrition: Nutrition) {
            let satFat = nutrition.satFat
            let cholesterol = nutrition.cholesterol
            let totalFat = nutrition.fat
            
            // Text
            self.fatAmount = StringFormatters.formatNutrientAmount(totalFat)
            self.fatDV = StringFormatters.formatDVPercent(nutrition.fatDVPercent)
            self.satFatAmount = StringFormatters.formatNutrientAmount(satFat)
            self.satFatDV = StringFormatters.formatDVPercent(nutrition.satFatDVPercent)
            self.cholesterolAmount = StringFormatters.formatNutrientAmount(cholesterol, unit: .milligrams)
            self.cholesterolDV = StringFormatters.formatDVPercent(nutrition.cholesterolDVPercent)
            
            // Bar chart
            var chartValues: [NutrientBreakdownBarChartView.Value] = []
            // Don't calculate if we don't have total carbs
            if let satFat = satFat, let totalFat = totalFat, totalFat > 0 {
                chartValues = NutrientBreakdownBarChartView.getValues(from: [
                    (satFat / totalFat, Color.App.SatFatIndicator)
                ], percentageForm: false)
            }
            self.barChartValues = chartValues
        }
    }
}

struct FatsSectionView_Previews: PreviewProvider {
    private static let vm = FatsSectionView.ViewModel(nutrition: PreviewNutritionModels.FullyParsedNutrition)

    static var previews: some View {
        ColorSchemePreview {
            FatsSectionView(vm: vm)
            .padding()
            .background(Color.App.BackgroundSecondaryFillColor)
        }.previewLayout(.sizeThatFits)
    }
    
}
