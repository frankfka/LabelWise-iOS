//
//  NutritionAnalysisHeaderView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-04.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct NutritionAnalysisResultsView: View {
    
    private var macroSummaryViewVm: MacronutrientSummaryView.ViewModel {
        MacronutrientSummaryView.ViewModel(
            dto: self.viewModel.resultDto.parsedNutrition,
            dailyValues: DailyNutritionValues()
        )
    }
    
    private let viewModel: ViewModel
    
    init(vm: ViewModel) {
        self.viewModel = vm
    }
    
    var body: some View {
        VStack {
            MacronutrientSummaryView(vm: self.macroSummaryViewVm)
                .modifier(AnalysisSectionModifier(title: "Macronutrients"))
            Spacer().fillHeight()
        }
        .padding(CGFloat.App.Layout.normalPadding)
        .fillWidthAndHeight()
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
