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

    private let dailyValues = DailyNutritionValues()
    private var insightsViewVm: InsightsSectionView.ViewModel {
        InsightsSectionView.ViewModel(dto: self.viewModel.resultDto)
    }
    private var macroSummaryViewVm: MacronutrientSectionView.ViewModel {
        MacronutrientSectionView.ViewModel(
            dto: self.viewModel.resultDto.parsedNutrition,
            dailyValues: dailyValues
        )
    }
    private var carbohydratesSectionViewVm: CarbohydratesSectionView.ViewModel {
        CarbohydratesSectionView.ViewModel(dto: self.viewModel.resultDto.parsedNutrition, dailyValues: dailyValues)
    }
    private var fatsSectionViewVm: FatsSectionView.ViewModel {
        FatsSectionView.ViewModel(dto: self.viewModel.resultDto.parsedNutrition, dailyValues: dailyValues)
    }
    
    private let viewModel: ViewModel
    private let parentSize: CGSize? // Making this nullable to make previews easier
    
    init(vm: ViewModel, parentSize: CGSize? = nil) {
        self.viewModel = vm
        self.parentSize = parentSize
    }
    
    var body: some View {
        VStack(spacing: NutritionAnalysisResultsView.SectionSpacing) {
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
        let resultDto: AnalyzeNutritionResponseDTO

        init(dto: AnalyzeNutritionResponseDTO) {
            self.resultDto = dto
        }
    }
}

struct NutritionAnalysisResultsView_Previews: PreviewProvider {
    private static let fullyParsedVm = NutritionAnalysisResultsView.ViewModel(
        dto: AnalyzeNutritionResponseDTO(
            status: .complete,
            parsedNutrition: PreviewNutritionModels.FullyParsedNutritionDto,
            insights: PreviewNutritionModels.MultipleInsightsPerType
        )
    )
    private static let partiallyParsedVm = NutritionAnalysisResultsView.ViewModel(
        dto: AnalyzeNutritionResponseDTO(
            status: .incomplete,
            parsedNutrition: PreviewNutritionModels.PartiallyParsedNutritionDto,
            insights: []
        )
    )
    private static let noneParsedVm = NutritionAnalysisResultsView.ViewModel(
        dto: AnalyzeNutritionResponseDTO(
            status: .incomplete,
            parsedNutrition: PreviewNutritionModels.NoneParsedNutritionDto,
            insights: []
        )
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
