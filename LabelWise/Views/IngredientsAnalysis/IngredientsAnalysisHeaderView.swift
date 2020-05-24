//
//  IngredientsAnalysisHeaderView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-23.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// MARK: View
struct IngredientsAnalysisHeaderView: View {
    private static let NumIngredientsAnalyzedNumericalFont: Font = Font.App.Heading
    private static let NumIngredientsAnalyzedFont: Font = Font.App.LargeText
    private static let ElementColor: Color = Color.App.White
    private static let NumIngredientsTextSpacing: CGFloat = CGFloat.App.Layout.SmallPadding
    private static let VerticalElementSpacing: CGFloat = CGFloat.App.Layout.SmallPadding
    
    private let viewModel: ViewModel
    init(vm: ViewModel) {
        self.viewModel = vm
    }
    
    // Shared background with AnalysisScrollView
    var background: some View {
        self.viewModel.backgroundColor
    }
    
    var body: some View {
        VStack(spacing: IngredientsAnalysisHeaderView.VerticalElementSpacing) {
            HStack(alignment: .bottom, spacing: IngredientsAnalysisHeaderView.NumIngredientsTextSpacing) {
                Spacer()
                Text(self.viewModel.numAnalyzedIngredients)
                    .withAppStyle(font: IngredientsAnalysisHeaderView.NumIngredientsAnalyzedNumericalFont,
                                  color: IngredientsAnalysisHeaderView.ElementColor)
                Text(self.viewModel.numAnalyzedIngredientsDescription)
                    .withAppStyle(font: IngredientsAnalysisHeaderView.NumIngredientsAnalyzedFont,
                                  color: IngredientsAnalysisHeaderView.ElementColor)
                    // Custom alignment guide so it looks more aligned
                    .alignmentGuide(.bottom) { d in d[.bottom] + 4 }
                Spacer()
            }
            // TODO: Number of warnings, etc.
        }
        .fillWidth()
        .background(self.background)
    }
}

// MARK: View Model
extension IngredientsAnalysisHeaderView {
    // TODO: different background colors
    struct ViewModel {
        private let analyzedIngredients: [AnalyzedIngredientDTO]
        var numAnalyzedIngredients: String {
            self.analyzedIngredients.count.toDouble().toString(numDecimalDigits: 0)
        }
        var numAnalyzedIngredientsDescription: String {
            "ingredient\(self.analyzedIngredients.count != 1 ? "s" : "") analyzed"
        }
        var backgroundColor: Color = Color.App.AppGreen
        
        init(analyzedIngredients: [AnalyzedIngredientDTO]) {
            self.analyzedIngredients = analyzedIngredients
        }
        
    }
}

struct IngredientsAnalysisHeaderView_Previews: PreviewProvider {
    private static let multipleIngredientsWithWarningsVm = IngredientsAnalysisHeaderView.ViewModel(
        analyzedIngredients: [
            PreviewIngredientsModels.AnalyzedIngredientNoInsights,
            PreviewIngredientsModels.AnalyzedIngredientDextrose,
            PreviewIngredientsModels.AnalyzedIngredientMultipleInsights
        ]
    )

    private static let oneIngredientVm = IngredientsAnalysisHeaderView.ViewModel(
        analyzedIngredients: [
            PreviewIngredientsModels.AnalyzedIngredientNoInsights
        ]
    )
    
    private static let noIngredientVm = IngredientsAnalysisHeaderView.ViewModel(
        analyzedIngredients: []
    )
    
    static var previews: some View {
        Group {
            IngredientsAnalysisHeaderView(vm: multipleIngredientsWithWarningsVm)
            IngredientsAnalysisHeaderView(vm: oneIngredientVm)
            IngredientsAnalysisHeaderView(vm: noIngredientVm)
        }
        .background(Color.App.BackgroundPrimaryFillColor)
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
