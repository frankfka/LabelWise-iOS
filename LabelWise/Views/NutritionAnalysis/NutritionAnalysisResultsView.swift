//
//  NutritionAnalysisHeaderView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-04.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct NutritionAnalysisResultsView: View {
    private static let SectionSpacing: CGFloat = CGFloat.App.Layout.LargePadding

    private var parsedNutritionViewVm: ParsedNutritionSectionView.ViewModel {
        ParsedNutritionSectionView.ViewModel(nutrition: self.viewModel.nutrition)
    }
    private var insightsViewVm: InsightsSectionView.ViewModel {
        InsightsSectionView.ViewModel(insights: self.viewModel.insights, nutrition: self.viewModel.nutrition)
    }
    private var macroSummaryViewVm: MacronutrientSectionView.ViewModel {
        MacronutrientSectionView.ViewModel(nutrition: self.viewModel.nutrition)
    }
    private var carbohydratesSectionViewVm: CarbohydratesSectionView.ViewModel {
        CarbohydratesSectionView.ViewModel(nutrition: self.viewModel.nutrition)
    }
    private var fatsSectionViewVm: FatsSectionView.ViewModel {
        FatsSectionView.ViewModel(nutrition: self.viewModel.nutrition)
    }
    
    private let viewModel: ViewModel
    private let parentSize: CGSize? // Making this nullable to make previews easier
    
    init(vm: ViewModel, parentSize: CGSize? = nil) {
        self.viewModel = vm
        self.parentSize = parentSize
    }
    
    var body: some View {
        VStack(spacing: NutritionAnalysisResultsView.SectionSpacing) {
            ParsedNutritionSectionView(vm: self.parsedNutritionViewVm)
                .modifier(AnalysisSectionModifier(alignment: .center))
            if self.insightsViewVm.hasMessages {
                InsightsSectionView(vm: self.insightsViewVm)
                    .modifier(AnalysisSectionModifier(title: "Insights", alignment: .leading))
            }
            MacronutrientSectionView(vm: self.macroSummaryViewVm, parentSize: self.parentSize)
                .modifier(AnalysisSectionModifier(title: "Macronutrients"))
            CarbohydratesSectionView(vm: self.carbohydratesSectionViewVm)
                .modifier(AnalysisSectionModifier(title: "Carbohydrates"))
            FatsSectionView(vm: self.fatsSectionViewVm)
                .modifier(AnalysisSectionModifier(title: "Fats"))
            Spacer()
        }
    }

    func getMinBodyDimension(from geometry: GeometryProxy) -> CGFloat {
        return min(geometry.size.width, geometry.size.height)
    }

}
extension NutritionAnalysisResultsView {
    struct ViewModel {
        let nutrition: Nutrition
        let insights: [NutritionInsightDTO]

        init(nutrition: Nutrition, insights: [NutritionInsightDTO]) {
            self.nutrition = nutrition
            self.insights = insights
        }
    }
}

struct NutritionAnalysisResultsView_Previews: PreviewProvider {
    private static let fullyParsedVm = NutritionAnalysisResultsView.ViewModel(
        nutrition: PreviewNutritionModels.FullyParsedNutrition,
        insights: PreviewNutritionModels.MultipleInsightsPerType
    )
    private static let partiallyParsedVm = NutritionAnalysisResultsView.ViewModel(
        nutrition: PreviewNutritionModels.PartiallyParsedNutrition,
        insights: []
    )
    private static let noneParsedVm = NutritionAnalysisResultsView.ViewModel(
        nutrition: PreviewNutritionModels.NoneParsedNutrition,
        insights: []
    )
    
    
    static var previews: some View {
        ColorSchemePreview {
            Group {
                NutritionAnalysisResultsView(vm: fullyParsedVm)
                NutritionAnalysisResultsView(vm: partiallyParsedVm)
                NutritionAnalysisResultsView(vm: noneParsedVm)
            }
            .background(Color.App.BackgroundPrimaryFillColor)
        }.previewLayout(.sizeThatFits)
    }
}
