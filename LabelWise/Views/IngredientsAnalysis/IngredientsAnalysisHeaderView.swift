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
    private static let NumIngredientsSectionBottomPadding: CGFloat = CGFloat.App.Layout.SmallPadding
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
            .padding(.bottom, IngredientsAnalysisHeaderView.NumIngredientsSectionBottomPadding)
            self.viewModel.numInsightsTextViewVm.map {
                AnalysisIconTextView(vm: $0)
            }
        }
        .fillWidth()
        .background(self.background)
    }
}

// MARK: View Model
extension IngredientsAnalysisHeaderView {
    struct ViewModel {
        private static let PositiveIcon: Image = Image.App.CheckmarkCircle
        private static let CautionIcon: Image = Image.App.ExclamationMarkCircle

        private let analyzedIngredients: [AnalyzedIngredientDTO]
        var numAnalyzedIngredients: String {
            self.analyzedIngredients.count.toDouble().toString(numDecimalDigits: 0)
        }
        var numAnalyzedIngredientsDescription: String {
            "ingredient\(self.analyzedIngredients.count != 1 ? "s" : "") analyzed"
        }
        private var allInsights: [IngredientInsightDTO] {
            self.analyzedIngredients.flatMap {
                $0.insights
            }
        }
        var numCautionWarnings: Int {
            self.allInsights.filter { $0.type == .cautionWarning }.count
        }
        var numSevereWarnings: Int {
            self.allInsights.filter { $0.type == .severeWarning }.count
        }
        var numPositiveWarnings: Int {
            self.allInsights.filter { $0.type == .positive }.count
        }
        var hasWarnings: Bool {
            numCautionWarnings + numSevereWarnings > 0
        }
        var backgroundColor: Color {
            if numSevereWarnings > 0 {
                return Color.App.AppRed
            } else if numCautionWarnings > 0 {
                return Color.App.AppYellow
            }
            return Color.App.AppGreen
        }
        // Shown if we have returned insights
        private var numInsightsText: String? {
            let numInsights = allInsights.count
            if numInsights > 0 {
                let numWarnings = numCautionWarnings + numSevereWarnings
                if numWarnings > 0 {
                    return " \(numWarnings) ingredient warning\(numWarnings > 1 ? "s" : "")"
                } else {
                    return "\(numInsights) insight\(numInsights > 1 ? "s" : "")"
                }
            }
            return nil
        }
        var numInsightsTextViewVm: AnalysisIconTextView.ViewModel? {
            numInsightsText.map {
                let icon = self.hasWarnings ? ViewModel.CautionIcon : ViewModel.PositiveIcon
                return AnalysisIconTextView.ViewModel(
                    text: $0,
                    icon: icon,
                    color: IngredientsAnalysisHeaderView.ElementColor
                )
            }
        }
        
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
