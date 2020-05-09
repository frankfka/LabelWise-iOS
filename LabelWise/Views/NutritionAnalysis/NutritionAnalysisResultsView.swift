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
    private var macroSummaryViewVm: MacronutrientSectionView.ViewModel {
        MacronutrientSectionView.ViewModel(
            dto: self.viewModel.resultDto.parsedNutrition,
            dailyValues: dailyValues
        )
    }
    private var carbohydratesSectionViewVm: CarbohydratesSectionView.ViewModel {
        CarbohydratesSectionView.ViewModel(dto: self.viewModel.resultDto.parsedNutrition, dailyValues: dailyValues)
    }
    
    private let viewModel: ViewModel
    
    init(vm: ViewModel) {
        self.viewModel = vm
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: NutritionAnalysisResultsView.SectionSpacing) {
                MacronutrientSectionView(vm: self.macroSummaryViewVm, approximateMinDimension: self.getMinBodyDimension(from: geometry))
                    .modifier(AnalysisSectionModifier(title: "Macronutrients"))
                CarbohydratesSectionView(vm: self.carbohydratesSectionViewVm)
                    .modifier(AnalysisSectionModifier(title: "Carbohydrates"))
                Spacer()
            }
            .padding(CGFloat.App.Layout.Padding)
            .fillWidthAndHeight()
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
    private static let vm = NutritionAnalysisResultsView.ViewModel(
        dto: AnalyzeNutritionResponseDTO(
            status: .complete,
            parsedNutrition: PreviewNutritionModels.FullyParsedNutritionDto,
            insights: []
        )
    )
    
    static var previews: some View {
        ColorSchemePreview {
            NutritionAnalysisResultsView(vm: vm)
                .background(Color.App.BackgroundPrimaryFillColor)
        }
    }
}
