//
//  CarbohydratesSectionView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-09.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// MARK: Main view
struct CarbohydratesSectionView: View {
    private static let VerticalItemSpacing: CGFloat = CGFloat.App.Layout.SmallestPadding
    private static let ChartBottomPadding: CGFloat = CGFloat.App.Layout.MediumPadding
    private static let AmountTextFont: Font = Font.App.NormalTextBold
    private static let AmountTextColor: Color = Color.App.Text
    private static let AmountTextSeparation: CGFloat = CGFloat.App.Layout.SmallestPadding
    private static let NutrientNameFont: Font = Font.App.NormalTextBold
    private static let DVFont: Font = Font.App.SmallText
    private static let DVColor: Color = Color.App.SecondaryText
    
    private let viewModel: ViewModel
    
    init(vm: ViewModel) {
        self.viewModel = vm
    }
    
    
    var body: some View {
        VStack(spacing: CarbohydratesSectionView.VerticalItemSpacing) {
            NutrientBreakdownBarChartView(values: self.viewModel.barChartValues)
                .padding(.bottom, CarbohydratesSectionView.ChartBottomPadding)
            NutrientDescriptionTextRowView(name: "Total", amount: self.viewModel.carbsAmount, dv: self.viewModel.carbsDV, indicatorColor: Color.App.Text)
            NutrientDescriptionTextRowView(name: "Sugar", amount: self.viewModel.sugarAmount, dv: self.viewModel.sugarDV, indicatorColor: Color.App.SugarIndicator)
            NutrientDescriptionTextRowView(name: "Fiber", amount: self.viewModel.fiberAmount, dv: self.viewModel.fiberDV, indicatorColor: Color.App.FiberIndicator)
        }
    }
}
// MARK: View model
extension CarbohydratesSectionView {
    struct ViewModel {
        // Values for breakdown chart
        let barChartValues: [NutrientBreakdownBarChartView.Value]
        // Strings for text breakdown
        let carbsAmount: String
        let carbsDV: String
        let sugarAmount: String
        let sugarDV: String
        let fiberAmount: String
        let fiberDV: String
        
        init(dto: AnalyzeNutritionResponseDTO.ParsedNutrition, dailyValues: DailyNutritionValues) {
            let sugar = dto.sugar
            let nonNilSugar = sugar ?? 0
            let fiber = dto.fiber
            let nonNilFiber = fiber ?? 0
            let totalCarbs = dto.carbohydrates
            
            // Text
            self.carbsAmount = StringFormatters.formatNutrientAmount(totalCarbs)
            self.carbsDV = StringFormatters.formatDVPercent(NutritionViewUtils.getDailyValuePercentage(amount: totalCarbs, dailyValue: dailyValues.carbohydrates))
            self.sugarAmount = StringFormatters.formatNutrientAmount(sugar)
            self.sugarDV = StringFormatters.formatDVPercent(NutritionViewUtils.getDailyValuePercentage(amount: sugar, dailyValue: dailyValues.sugar))
            self.fiberAmount = StringFormatters.formatNutrientAmount(fiber)
            self.fiberDV = StringFormatters.formatDVPercent(NutritionViewUtils.getDailyValuePercentage(amount: fiber, dailyValue: dailyValues.fiber))
            
            // Bar chart
            var chartValues: [NutrientBreakdownBarChartView.Value] = []
            // Don't calculate if we don't have total carbs
            if let totalCarbs = totalCarbs, totalCarbs > 0 {
                chartValues = NutrientBreakdownBarChartView.getValues(from: [
                    (nonNilSugar / totalCarbs, Color.App.SugarIndicator),
                    (nonNilFiber / totalCarbs, Color.App.FiberIndicator)
                ], percentageForm: false)
            }
            self.barChartValues = chartValues
        }
    }
}

struct CarbohydratesSectionView_Previews: PreviewProvider {
    private static let vm = CarbohydratesSectionView.ViewModel(dto: PreviewNutritionModels.FullyParsedNutritionDto,
                                                               dailyValues: DailyNutritionValues())
    
    static var previews: some View {
        ColorSchemePreview {
            CarbohydratesSectionView(vm: vm)
            .padding()
            .background(Color.App.BackgroundSecondaryFillColor)
        }.previewLayout(.sizeThatFits)
    }
}
