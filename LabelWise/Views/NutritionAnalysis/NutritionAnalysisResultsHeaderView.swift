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
    private static let NumInsightsFont: Font = Font.App.LargeText
    private static let ElementColor: Color = Color.App.White
    private static let CalorieTextSpacing: CGFloat = CGFloat.App.Layout.SmallestPadding
    private static let CalorieSectionBottomPadding: CGFloat = CGFloat.App.Layout.SmallPadding
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
        VStack(spacing: NutritionAnalysisResultsHeaderView.VerticalElementSpacing) {
            HStack(alignment: .bottom, spacing: NutritionAnalysisResultsHeaderView.CalorieTextSpacing) {
                Spacer()
                Text(self.viewModel.caloriesText)
                    .withStyle(font: NutritionAnalysisResultsHeaderView.CaloriesNumericalFont,
                            color: NutritionAnalysisResultsHeaderView.ElementColor)
                Text("cals")
                    .withStyle(font: NutritionAnalysisResultsHeaderView.CaloriesDescriptionFont,
                            color: NutritionAnalysisResultsHeaderView.ElementColor)
                    // Custom alignment guide so it looks more aligned
                    .alignmentGuide(.bottom) { d in d[.bottom] + 4 }
                Spacer()
            }
            .padding(.bottom, NutritionAnalysisResultsHeaderView.CalorieSectionBottomPadding)
            AnalysisIconTextView(
                text: self.viewModel.parseResultText,
                type: self.viewModel.didParseAll ? .positive : .cautionWarning,
                customColor: NutritionAnalysisResultsHeaderView.ElementColor
            )
            self.viewModel.numInsightsText.map {
                AnalysisIconTextView(
                    text: $0,
                    type: self.viewModel.hasWarnings ? .cautionWarning : .positive,
                    customColor: NutritionAnalysisResultsHeaderView.ElementColor
                )
            }
        }
        .fillWidth()
        .background(self.background)
    }
}

extension NutritionAnalysisResultsHeaderView {
    struct ViewModel {
        // Root data
        private let insights: [NutritionInsightDTO]
        private let nutrition: Nutrition
        private let parseStatus: AnalyzeNutritionResponseDTO.Status
        // Computed view constants
        var numCautionWarnings: Int {
            insights.filter { $0.type == .cautionWarn }.count
        }
        var numSevereWarnings: Int {
            insights.filter { $0.type == .cautionSevere }.count
        }
        var hasWarnings: Bool {
            numCautionWarnings + numSevereWarnings > 0
        }
        var numPositiveWarnings: Int {
            insights.filter { $0.type == .positive }.count
        }
        // Background color
        var backgroundColor: Color {
            if numSevereWarnings > 0 {
                return Color.App.AppRed
            } else if numCautionWarnings > 0 {
                return Color.App.AppYellow
            }
            return Color.App.AppGreen
        }
        var caloriesText: String {
            if let calories = nutrition.calories {
                return calories.toString(numDecimalDigits: 1)
            }
            return StringFormatters.NoNumberPlaceholderText
        }
        var numInsightsText: String? {
            let numInsights = insights.count
            if numInsights > 0 {
                let numWarnings = numCautionWarnings + numSevereWarnings
                if numWarnings > 0 {
                    return " \(numWarnings) nutrition warning\(numWarnings > 1 ? "s" : "")"
                } else {
                    return "\(numInsights) insight\(numInsights > 1 ? "s" : "")"
                }
            }
            return nil
        }
        var didParseAll: Bool { parseStatus == .complete }
        var parseResultText: String {
            didParseAll ? "Parsed complete nutritional profile" : "Nutritional information is incomplete"
        }

        init(nutrition: Nutrition, insights: [NutritionInsightDTO], parseStatus: AnalyzeNutritionResponseDTO.Status) {
            self.parseStatus = parseStatus
            self.nutrition = nutrition
            self.insights = insights
        }
    }
}

struct NutritionAnalysisResultsHeaderView_Previews: PreviewProvider {
    private static let vm = NutritionAnalysisResultsHeaderView.ViewModel(
        nutrition: PreviewNutritionModels.FullyParsedNutrition,
        insights: [],
        parseStatus: .complete
    )

    static var previews: some View {
        NutritionAnalysisResultsHeaderView(vm: vm)
    }
}
