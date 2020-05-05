//
//  NutritionAnalysisHeaderView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-04.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct NutritionAnalysisResultsView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Test")
            Spacer()
        }
        .fillWidthAndHeight()
    }
}
extension NutritionAnalysisResultsView {
    struct ViewModel {
        private let resultDto: AnalyzeNutritionResponseDTO

        init(dto: AnalyzeNutritionResponseDTO) {
            self.resultDto = dto
        }
    }
}

struct NutritionAnalysisResultsView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionAnalysisResultsView()
    }
}
