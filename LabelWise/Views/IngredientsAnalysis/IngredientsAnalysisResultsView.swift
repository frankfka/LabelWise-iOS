//
//  IngredientsAnalysisResultsView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-22.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// MARK: View
struct IngredientsAnalysisResultsView: View {
    private static let SectionSpacing: CGFloat = CGFloat.App.Layout.LargePadding
    private static let AnalyzedIngredientRowSpacing: CGFloat = CGFloat.App.Layout.SmallPadding

    private let viewModel: ViewModel
    private var analyzedIngredientsSectionVm: AnalyzedIngredientsSectionView.ViewModel {
        AnalyzedIngredientsSectionView.ViewModel(analyzedIngredients: self.viewModel.dto.analyzedIngredients)
    }
    private var parsedIngredientsSectionVm: AllParsedIngredientsSectionView.ViewModel {
        AllParsedIngredientsSectionView.ViewModel(parsedIngredients: self.viewModel.dto.parsedIngredients)
    }

    init(vm: ViewModel) {
        self.viewModel = vm
    }

    var body: some View {
        VStack(spacing: IngredientsAnalysisResultsView.SectionSpacing) {
            AnalyzedIngredientsSectionView(vm: self.analyzedIngredientsSectionVm)
                .modifier(AnalysisSectionModifier(title: "Analyzed Ingredients"))
            AllParsedIngredientsSectionView(vm: self.parsedIngredientsSectionVm)
                .modifier(AnalysisSectionModifier(title: "Parsed Ingredients"))
            Spacer()
        }
    }
}

// MARK: View Model
extension IngredientsAnalysisResultsView {
    struct ViewModel {
        let dto: AnalyzeIngredientsResponseDTO
    }
}

struct IngredientsAnalysisResultsView_Previews: PreviewProvider {

    private static let completeVm = IngredientsAnalysisResultsView.ViewModel(
        dto: PreviewIngredientsModels.ResponseWithAllTypes
    )
    private static let noAnalyzedIngredientsVm = IngredientsAnalysisResultsView.ViewModel(
        dto: PreviewIngredientsModels.ResponseWithNoAnalyzedIngredients
    )
    // This should actually be an error case
    private static let noParsedIngredientsVm = IngredientsAnalysisResultsView.ViewModel(
        dto: PreviewIngredientsModels.ResponseWithNoParsedIngredients
    )

    static var previews: some View {
        ColorSchemePreview {
            Group {
                IngredientsAnalysisResultsView(vm: completeVm)
                IngredientsAnalysisResultsView(vm: noAnalyzedIngredientsVm)
                IngredientsAnalysisResultsView(vm: noParsedIngredientsVm)
            }
            .background(Color.App.BackgroundPrimaryFillColor)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
