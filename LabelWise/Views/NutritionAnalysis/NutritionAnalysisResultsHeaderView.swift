//
//  NutritionAnalysisResultsHeaderView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-04.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct NutritionAnalysisResultsHeaderView: View {

    private static let CaloriesNumericalFont: Font = Font.App.Heading
    private static let CaloriesDescriptionFont: Font = Font.App.LargeText
    private static let ElementColor: Color = Color.App.White

    private let viewModel: ViewModel
    init(vm: ViewModel) {
        self.viewModel = vm
    }

    // Shared background with AnalysisScrollView
    var background: some View {
        self.viewModel.backgroundColor
    }

    var body: some View {
        HStack(alignment: .bottom) {
            Spacer()
            Text(self.viewModel.caloriesText)
                .withStyle(font: Font.App.Heading, color: Color.App.White)
            Text("cals")
                .withStyle(font: Font.App.LargeText, color: Color.App.White)
                // Custom alignment guide so it looks more aligned
                .alignmentGuide(.bottom) { d in d[.bottom] + 4 }
            Spacer()
        }
        .fillWidth()
        .background(self.background)
    }
}

extension NutritionAnalysisResultsHeaderView {
    struct ViewModel {
        // Root response
        private let resultDto: AnalyzeNutritionResponseDTO
        // Computed view constants
        var backgroundColor: Color {
            if resultDto.insights.isEmpty {
                // TODO: Change this to fit insights structure
                return Color.App.AppGreen
            } else {
                return Color.App.AppYellow
            }
        }
        var caloriesText: String {
            if let calories = resultDto.parsedNutrition.calories {
                return calories.toString(numDecimalDigits: 1)
            }
            return String.NoNumberPlaceholderText
        }

        init(dto: AnalyzeNutritionResponseDTO) {
            self.resultDto = dto
        }
    }
}

struct NutritionAnalysisResultsHeaderView_Previews: PreviewProvider {
    private static let vm = NutritionAnalysisResultsHeaderView.ViewModel(dto: AnalyzeNutritionResponseDTO(
            status: .complete,
            parsedNutrition: PreviewNutritionModels.FullyParsedNutritionDto,
            insights: [])
    )

    static var previews: some View {
        NutritionAnalysisResultsHeaderView(vm: vm)
    }
}
