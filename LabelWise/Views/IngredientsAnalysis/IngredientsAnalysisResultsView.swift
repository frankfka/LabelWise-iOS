//
//  IngredientsAnalysisResultsView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-22.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// TODO: no ingredients case
// MARK: View
struct IngredientsAnalysisResultsView: View {
    private static let SectionSpacing: CGFloat = CGFloat.App.Layout.SmallPadding

    private let viewModel: ViewModel
    private var analyzedIngredientViewModels: [IngredientInfoItemView.ViewModel] {
        self.viewModel.analyzedIngredients.map {
            IngredientInfoItemView.ViewModel(dto: $0)
        }
    }

    init(vm: ViewModel) {
        self.viewModel = vm
    }

    var body: some View {
        VStack(spacing: IngredientsAnalysisResultsView.SectionSpacing) {
            ForEach(0..<self.analyzedIngredientViewModels.count, id: \.self) { idx in
                IngredientInfoItemView(vm: self.analyzedIngredientViewModels[idx])
            }
            Spacer()
        }
    }
}
// MARK: View Model
extension IngredientsAnalysisResultsView {
    struct ViewModel {
        let analyzedIngredients: [AnalyzedIngredientDTO]
    }
}

struct IngredientsAnalysisResultsView_Previews: PreviewProvider {
    private static let multipleIngredientsWithWarningsVm = IngredientsAnalysisResultsView.ViewModel(
        analyzedIngredients: [
            PreviewIngredientsModels.AnalyzedIngredientNoInsights,
            PreviewIngredientsModels.AnalyzedIngredientDextrose,
            PreviewIngredientsModels.AnalyzedIngredientMultipleInsights
        ]
    )

    private static let oneIngredientVm = IngredientsAnalysisResultsView.ViewModel(
        analyzedIngredients: [
            PreviewIngredientsModels.AnalyzedIngredientNoInsights
        ]
    )

    private static let noIngredientVm = IngredientsAnalysisResultsView.ViewModel(
        analyzedIngredients: []
    )

    static var previews: some View {
        ColorSchemePreview {
            Group {
                IngredientsAnalysisResultsView(vm: multipleIngredientsWithWarningsVm)
                IngredientsAnalysisResultsView(vm: oneIngredientVm)
                IngredientsAnalysisResultsView(vm: noIngredientVm)
            }
            .background(Color.App.BackgroundPrimaryFillColor)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
