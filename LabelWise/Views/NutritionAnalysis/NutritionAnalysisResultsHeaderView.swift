//
//  NutritionAnalysisResultsHeaderView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-04.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct NutritionAnalysisResultsHeaderView: View {

    // Shared background with AnalysisScrollView
    var background: some View {
        Color.App.AppGreen
    }

    var body: some View {
        Text("Loading")
            .withStyle(font: Font.App.heading, color: Color.white)
    }
}

extension NutritionAnalysisResultsHeaderView {
    struct ViewModel {
        private let resultDto: AnalyzeNutritionResponseDTO

        init(dto: AnalyzeNutritionResponseDTO) {
            self.resultDto = dto
        }
    }
}

struct NutritionAnalysisResultsHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionAnalysisResultsHeaderView()
    }
}
