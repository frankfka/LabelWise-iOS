//
//  AnalyzedIngredientsSectionView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-23.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// MARK: View
struct AnalyzedIngredientsSectionView: View {
    private static let AnalyzedIngredientRowSpacing: CGFloat = CGFloat.App.Layout.SmallPadding
    
    private static let NoAnalyzedIngredientsTextPadding: CGFloat = CGFloat.App.Layout.Padding
    private static let NoAnalyzedIngredientsTextFont: Font = Font.App.NormalText
    private static let NoAnalyzedIngredientsTextColor: Color = Color.App.Text
    
    private let viewModel: ViewModel
    private var analyzedIngredientViewModels: [AnalyzedIngredientInfoItemView.ViewModel] {
        self.viewModel.analyzedIngredients.map {
            AnalyzedIngredientInfoItemView.ViewModel(dto: $0)
        }
    }
    
    init(vm: ViewModel) {
        self.viewModel = vm
    }
    
    var body: some View {
        VStack(spacing: AnalyzedIngredientsSectionView.AnalyzedIngredientRowSpacing) {
            if self.viewModel.hasAnalyzedIngredients {
                ForEach(0..<self.analyzedIngredientViewModels.count, id: \.self) { idx in
                    AnalyzedIngredientInfoItemView(vm: self.analyzedIngredientViewModels[idx])
                }
            } else {
                Text("No ingredients were analyzed.")
                    .withAppStyle(
                        font: AnalyzedIngredientsSectionView.NoAnalyzedIngredientsTextFont,
                        color: AnalyzedIngredientsSectionView.NoAnalyzedIngredientsTextColor
                    )
                    .padding(AnalyzedIngredientsSectionView.NoAnalyzedIngredientsTextPadding)
            }
        }
    }
}
// MARK: View Model
extension AnalyzedIngredientsSectionView {
    struct ViewModel {
        let analyzedIngredients: [AnalyzedIngredientDTO]
        var hasAnalyzedIngredients: Bool {
            !self.analyzedIngredients.isEmpty
        }

        init(analyzedIngredients: [AnalyzedIngredientDTO]) {
            self.analyzedIngredients = analyzedIngredients.sorted { one, two in
                two.name > one.name
            }
        }
    }
}

struct AnalyzedIngredientsSectionView_Previews: PreviewProvider {
    private static let multipleIngredientsWithWarningsVm = AnalyzedIngredientsSectionView.ViewModel(
        analyzedIngredients: [
            PreviewIngredientsModels.AnalyzedIngredientNoInsights,
            PreviewIngredientsModels.AnalyzedIngredientDextrose,
            PreviewIngredientsModels.AnalyzedIngredientMultipleInsights
        ]
    )

    private static let oneIngredientVm = AnalyzedIngredientsSectionView.ViewModel(
        analyzedIngredients: [
            PreviewIngredientsModels.AnalyzedIngredientNoInsights
        ]
    )

    private static let noIngredientVm = AnalyzedIngredientsSectionView.ViewModel(
        analyzedIngredients: []
    )

    static var previews: some View {
        ColorSchemePreview {
            Group {
                AnalyzedIngredientsSectionView(vm: multipleIngredientsWithWarningsVm)
                AnalyzedIngredientsSectionView(vm: oneIngredientVm)
                AnalyzedIngredientsSectionView(vm: noIngredientVm)
            }
            .padding()
            .background(Color.App.BackgroundSecondaryFillColor)
        }
        .previewLayout(.sizeThatFits)
    }
}
